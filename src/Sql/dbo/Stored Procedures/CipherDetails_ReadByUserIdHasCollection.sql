﻿CREATE PROCEDURE [dbo].[CipherDetails_ReadByUserIdHasCollection]
    @UserId UNIQUEIDENTIFIER
AS
BEGIN
    SET NOCOUNT ON

    SELECT
        C.*
    FROM
        [dbo].[CipherDetails](@UserId) C
    INNER JOIN
        [dbo].[Organization] O ON C.[UserId] IS NULL AND O.[Id] = C.[OrganizationId]
    INNER JOIN
        [dbo].[OrganizationUser] OU ON OU.[OrganizationId] = O.[Id] AND OU.[UserId] = @UserId
    LEFT JOIN
        [dbo].[CollectionCipher] SC ON C.[UserId] IS NULL AND OU.[AccessAllCollections] = 0 AND SC.[CipherId] = C.[Id]
    LEFT JOIN
        [dbo].[CollectionUser] SU ON SU.[CollectionId] = SC.[CollectionId] AND SU.[OrganizationUserId] = OU.[Id]
    WHERE
        OU.[Status] = 2 -- 2 = Confirmed
        AND O.[Enabled] = 1
        AND (OU.[AccessAllCollections] = 1 OR SU.[CollectionId] IS NOT NULL)
END