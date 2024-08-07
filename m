Received: from fout2-smtp.messagingengine.com (fout2-smtp.messagingengine.com [103.168.172.145])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C2EE4190464;
	Wed,  7 Aug 2024 03:40:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=103.168.172.145
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723002026; cv=none; b=h1W4orI8u3VIp2XItSLEL086lNDnFdPpgWKn1t8MVwbmW/O2hYA9ycoHD6yhRBcV5mlcLQswdb7UnxBVVhdBv8AUFosxtnAlsGrs6XzSQSxOPqfgNk0S1lyTwUN9fnNTeXo8UYnAVkVyy4dW9p7OJG/JNtl/KRGdt1DBw8W3pUU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723002026; c=relaxed/simple;
	bh=6qLLfjhX0tZiP2H4jz2shkgck70CQ7aC1/wNyf6TcPw=;
	h=To:Cc:Message-Id:In-Reply-To:References:From:Subject:Date; b=PwkrmmTb0ums2H2jD+ReDgytfMXNaMpWyI53tPJzx+PEzzbVX9TmfW9aIRymqZqbj2FxPvDCRAvNL1VVaXbYASZKai9OwFyXHK3cM8UNAO8hBbt5qAq/e5eN9zUF6wMBjvVFv2Bu+7b7lrswSbHtqfUfz1sZLBa63HYv9BOJChM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=linux-m68k.org; spf=none smtp.mailfrom=linux-m68k.org; dkim=pass (2048-bit key) header.d=messagingengine.com header.i=@messagingengine.com header.b=nUpMPUwv; arc=none smtp.client-ip=103.168.172.145
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=linux-m68k.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=linux-m68k.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=messagingengine.com header.i=@messagingengine.com header.b="nUpMPUwv"
Received: from compute5.internal (compute5.nyi.internal [10.202.2.45])
	by mailfout.nyi.internal (Postfix) with ESMTP id D76A3138FD03;
	Tue,  6 Aug 2024 23:40:23 -0400 (EDT)
Received: from mailfrontend2 ([10.202.2.163])
  by compute5.internal (MEProxy); Tue, 06 Aug 2024 23:40:23 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	messagingengine.com; h=cc:cc:content-type:date:date:feedback-id
	:feedback-id:from:from:in-reply-to:in-reply-to:message-id
	:references:reply-to:subject:subject:to:to:x-me-proxy:x-me-proxy
	:x-me-sender:x-me-sender:x-sasl-enc; s=fm3; t=1723002023; x=
	1723088423; bh=vLn0goGDX4sqfQLpdSkswCxsEwLWmBY95Y+aKANfndA=; b=n
	UpMPUwvHxSDx4WeqwxB4GZbZqvb6q0j4lhjMycmLlsqA9ygngNAf1VVrwDWAZxEG
	LLo0uATazNurr3KjNqZzEdMUaKjtgPH48ER5oy0JGp4DsuonDC1IqFMakgtvP7+v
	zN12bBnd9FXm5/9KnIya5BuwShCMGuOgwv5v5cJpp6nOKh5vyIzaoRBVwaZO3z1a
	Pa8qV+jiZzOpjUBzYvP1amWY0sF5LUqea8xtfr/ruOPGqj0P8xcGl4cmcy8w6voa
	ICSF24s6C0jYcprYKxNq5ODDytI5jvLKr/aKT3IrUewU2w+U2XXGsZABbklBq+g4
	h+ZZzYg4fuQcGk346YHEA==
X-ME-Sender: <xms:p-yyZu1zd5OgH_am8_BoBJF58DIQFMqce-4ixrxA3lfJxZW9TNqnUQ>
    <xme:p-yyZhFmdchCsfKiMJg_UPhMiDfVyj1KLxDf8IP3pdVUj4bnyJL3aGskOXPuVd9B-
    dKp5OZa0D8QZ56_qJw>
X-ME-Received: <xmr:p-yyZm4TvKCTmSrrfyEy_Olg_dcBiQHrYamDidlJRDQJU9bupoUldLlNjWc_3IP01lnWc4cE00PepGLivcK95645k0gX3XuvSwA>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeeftddrkeelgdejiecutefuodetggdotefrodftvf
    curfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfghnecu
    uegrihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmdenuc
    fjughrpefvvefkjghfhffuffestddtredttddttdenucfhrhhomhephfhinhhnucfvhhgr
    ihhnuceofhhthhgrihhnsehlihhnuhigqdhmieekkhdrohhrgheqnecuggftrfgrthhtvg
    hrnhepvefggfdthffhfeevuedugfdtuefgfeettdevkeeigefgudelteeggeeuheegffff
    necuvehluhhsthgvrhfuihiivgepvdenucfrrghrrghmpehmrghilhhfrhhomhepfhhthh
    grihhnsehlihhnuhigqdhmieekkhdrohhrghdpnhgspghrtghpthhtoheptd
X-ME-Proxy: <xmx:p-yyZv2F1PtE8T7TCpYRl6sJzc_eMvAiRVU9tTBWL8S49YBEcjJ06A>
    <xmx:p-yyZhEfXlG0kUh3EdN7p5nBdtZjYggluX62rcR8RJT7gDeI3pUyBA>
    <xmx:p-yyZo8cjxdkmtu8rOrP1OY4tnFBS30tzE5aX2OVO80jGSpvnKqtrw>
    <xmx:p-yyZmk0CWQdqH7nX1g-7-8WNpzdL9ao7CIxd5-fjX34jgntfuyRFA>
    <xmx:p-yyZo2WuGIKea_yxRoGiD23vDNHLk_WST7OtdNXWXImfFuvif_ZP4S9>
Feedback-ID: i58a146ae:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Tue,
 6 Aug 2024 23:40:21 -0400 (EDT)
To: "James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>,
    "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: Hannes Reinecke <hare@suse.com>,
    Michael Schmitz <schmitzmic@gmail.com>,
    Ondrej Zary <linux@zary.sk>,
    Stan Johnson <userm57@yahoo.com>,
    linux-scsi@vger.kernel.org,
    linux-kernel@vger.kernel.org
Message-Id: <f155ba5ce93055cbc6ac6d4026673f40f826edb8.1723001788.git.fthain@linux-m68k.org>
In-Reply-To: <cover.1723001788.git.fthain@linux-m68k.org>
References: <cover.1723001788.git.fthain@linux-m68k.org>
From: Finn Thain <fthain@linux-m68k.org>
Subject: [PATCH 05/11] scsi: mac_scsi: Enable scatter/gather by default
Date: Wed, 07 Aug 2024 13:36:28 +1000
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>

Now that FLAG_DMA_FIXUP has itself been fixed up, it can be used to enable
scatter/gather. Increase the default value for sg_tablesize to SG_ALL
for those systems which are compatible with FLAG_DMA_FIXUP.

Tested-by: Stan Johnson <userm57@yahoo.com>
Signed-off-by: Finn Thain <fthain@linux-m68k.org>
---
 drivers/scsi/mac_scsi.c | 8 +++++++-
 1 file changed, 7 insertions(+), 1 deletion(-)

diff --git a/drivers/scsi/mac_scsi.c b/drivers/scsi/mac_scsi.c
index 2e9fad1e3069..6ab7d82c9a99 100644
--- a/drivers/scsi/mac_scsi.c
+++ b/drivers/scsi/mac_scsi.c
@@ -432,7 +432,7 @@ static struct scsi_host_template mac_scsi_template = {
 	.eh_host_reset_handler	= macscsi_host_reset,
 	.can_queue		= 16,
 	.this_id		= 7,
-	.sg_tablesize		= 1,
+	.sg_tablesize		= SG_ALL,
 	.cmd_per_lun		= 2,
 	.dma_boundary		= PAGE_SIZE - 1,
 	.cmd_size		= sizeof(struct NCR5380_cmd),
@@ -470,6 +470,9 @@ static int __init mac_scsi_probe(struct platform_device *pdev)
 	if (setup_hostid >= 0)
 		mac_scsi_template.this_id = setup_hostid & 7;
 
+	if (macintosh_config->ident == MAC_MODEL_IIFX)
+		mac_scsi_template.sg_tablesize = 1;
+
 	instance = scsi_host_alloc(&mac_scsi_template,
 	                           sizeof(struct NCR5380_hostdata));
 	if (!instance)
@@ -491,6 +494,9 @@ static int __init mac_scsi_probe(struct platform_device *pdev)
 
 	host_flags |= setup_toshiba_delay > 0 ? FLAG_TOSHIBA_DELAY : 0;
 
+	if (instance->sg_tablesize > 1)
+		host_flags |= FLAG_DMA_FIXUP;
+
 	error = NCR5380_init(instance, host_flags | FLAG_LATE_DMA_SETUP);
 	if (error)
 		goto fail_init;
-- 
2.39.5

