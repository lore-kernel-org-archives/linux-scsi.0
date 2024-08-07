Received: from fhigh7-smtp.messagingengine.com (fhigh7-smtp.messagingengine.com [103.168.172.158])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D8AE415B999;
	Wed,  7 Aug 2024 03:40:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=103.168.172.158
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723002052; cv=none; b=F8I38/d5LRz6HuxuNIWxprItSuSx8uJuT76L/OzKxFkva+MLuY8kepda5FgJd8uiZlGB8rsfr2Hvo8vpfbSD+O3AHCEaOYNCP6Ax76jLTlGNKU3s7U2OdEs+RTCQN6fBij6r24a/5sY1k0wSGAPRtePsu8r18ofZJ5heEbZITkE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723002052; c=relaxed/simple;
	bh=jLbujuwX1NYE+yqIhuww+32AEghcK7DcynNhewCCOfE=;
	h=To:Cc:Message-Id:In-Reply-To:References:From:Subject:Date; b=cvGa3EPKqymlm3u5Ag5rxGAqoo2rOulDGTHQSL9YkFHXUWQhYxRHSA9bIMgwfzwaaX9FN4kJTBUZVbrtT48vJqSYtTZF0zQHr3MKT+3Tq9iEt9tRQUKuz9iQKLk7TkEl60qITsF3z3HsdNTtD6U1YlqmMvqJwbvN+BxJE67VpqE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=linux-m68k.org; spf=none smtp.mailfrom=linux-m68k.org; dkim=pass (2048-bit key) header.d=messagingengine.com header.i=@messagingengine.com header.b=robutoWW; arc=none smtp.client-ip=103.168.172.158
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=linux-m68k.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=linux-m68k.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=messagingengine.com header.i=@messagingengine.com header.b="robutoWW"
Received: from compute3.internal (compute3.nyi.internal [10.202.2.43])
	by mailfhigh.nyi.internal (Postfix) with ESMTP id DBE6F1151ADF;
	Tue,  6 Aug 2024 23:40:49 -0400 (EDT)
Received: from mailfrontend2 ([10.202.2.163])
  by compute3.internal (MEProxy); Tue, 06 Aug 2024 23:40:49 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	messagingengine.com; h=cc:cc:content-type:date:date:feedback-id
	:feedback-id:from:from:in-reply-to:in-reply-to:message-id
	:references:reply-to:subject:subject:to:to:x-me-proxy:x-me-proxy
	:x-me-sender:x-me-sender:x-sasl-enc; s=fm3; t=1723002049; x=
	1723088449; bh=mGei8bWlHgZ47cKZKJ967a3+QAaYqQpu5hJJ1AI2pzM=; b=r
	obutoWWw/MMapvdVVp07hqWaQKLk2oTO25the+NmJYL2o3NLzCwEq3bCdOAvJO+Y
	qMjM2lOAgFBgHNOrjVWVt5CXTuH7uXmkhlDi1iRIk5Kc7+ETy5POXv7IoRH3cB5d
	ghWWvrRjsApgE3t2am6IhWiDNuAfcwIMHulQsgmL/1VkVDl9W9N0+Y5DR6lp3/Ll
	abtvQJzStu8viwFcWFITe8FQ5bWjQadjNCXVcvudhDB8A+5XLT8Czr5kv0ApvOKn
	EO2gOAAU/a2XR38f6PDXiyV02mOJ2psSwc9k17GpTHFW6nURzYWYIVP1y50luzse
	BmkiA4m/bII6v3dJ1HIMA==
X-ME-Sender: <xms:weyyZrkVYKFv6vaQvMT6ziTfrKNr6VJdaiGsrQzm6D_nkSLjOAzleA>
    <xme:weyyZu2R78WetCeug6jXtpTDB1keCQAJ9-hM940iIe7NnQeVgCs4wD3TE48IgzJjQ
    DDddtfs9X5nAEkO2P8>
X-ME-Received: <xmr:weyyZhpo-IcmOPLGbnt6NPM-wpW57MIRoFViST3ZPB3U_ISjZ9Xb4N9paI-cewZLgUCaf_OZ05IfP_wnFKm3FwJ6G8ShhnfD7M0>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeeftddrkeelgdejiecutefuodetggdotefrodftvf
    curfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfghnecu
    uegrihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmdenuc
    fjughrpefvvefkjghfhffuffestddtredttddttdenucfhrhhomhephfhinhhnucfvhhgr
    ihhnuceofhhthhgrihhnsehlihhnuhigqdhmieekkhdrohhrgheqnecuggftrfgrthhtvg
    hrnhepvefggfdthffhfeevuedugfdtuefgfeettdevkeeigefgudelteeggeeuheegffff
    necuvehluhhsthgvrhfuihiivgeptdenucfrrghrrghmpehmrghilhhfrhhomhepfhhthh
    grihhnsehlihhnuhigqdhmieekkhdrohhrghdpnhgspghrtghpthhtoheptd
X-ME-Proxy: <xmx:weyyZjkbJ9v4GN66yLB6GFPvy5B1iQc5NcAjTAHgV0nbCy0tz9J5IA>
    <xmx:weyyZp2R6zTdagMLO0EmiNBX1WrnVYhirjkPdH7RH95lnHRmtk5R4g>
    <xmx:weyyZiuqwhAmeIltEaFuCozUbTWJDPyJntvZ5BGtPP9ZUmpYLUTL1w>
    <xmx:weyyZtWnBqTWohMzHYIxtNFqB3Em-6P5empb5V1Bfy1z7YAwHN9OcQ>
    <xmx:weyyZmlxxRK3zh-saBk-f6G7GQvJCIsU2zF0RmFpJVhusupBUnN4rvNP>
Feedback-ID: i58a146ae:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Tue,
 6 Aug 2024 23:40:47 -0400 (EDT)
To: "James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>,
    "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: Hannes Reinecke <hare@suse.com>,
    Michael Schmitz <schmitzmic@gmail.com>,
    Ondrej Zary <linux@zary.sk>,
    Stan Johnson <userm57@yahoo.com>,
    linux-scsi@vger.kernel.org,
    linux-kernel@vger.kernel.org
Message-Id: <4dc903a95a814d0c9b09656f3651a1bd798fcbbb.1723001788.git.fthain@linux-m68k.org>
In-Reply-To: <cover.1723001788.git.fthain@linux-m68k.org>
References: <cover.1723001788.git.fthain@linux-m68k.org>
From: Finn Thain <fthain@linux-m68k.org>
Subject: [PATCH 08/11] scsi: NCR5380: Drop redundant member from struct
 NCR5380_cmd
Date: Wed, 07 Aug 2024 13:36:28 +1000
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>

The 'message' member is stored but never loaded so just remove it.

Tested-by: Stan Johnson <userm57@yahoo.com>
Signed-off-by: Finn Thain <fthain@linux-m68k.org>
---
 drivers/scsi/NCR5380.c | 2 --
 drivers/scsi/NCR5380.h | 1 -
 2 files changed, 3 deletions(-)

diff --git a/drivers/scsi/NCR5380.c b/drivers/scsi/NCR5380.c
index 8a9df2ab9569..a47a825e7220 100644
--- a/drivers/scsi/NCR5380.c
+++ b/drivers/scsi/NCR5380.c
@@ -157,7 +157,6 @@ static inline void initialize_SCp(struct scsi_cmnd *cmd)
 	}
 
 	ncmd->status = 0;
-	ncmd->message = 0;
 }
 
 static inline void advance_sg_buffer(struct NCR5380_cmd *ncmd)
@@ -1807,7 +1806,6 @@ static void NCR5380_information_transfer(struct Scsi_Host *instance)
 				NCR5380_transfer_pio(instance, &phase, &len, &data, 0);
 				if (tmp == 0xff)
 					break;
-				ncmd->message = tmp;
 
 				switch (tmp) {
 				case ABORT:
diff --git a/drivers/scsi/NCR5380.h b/drivers/scsi/NCR5380.h
index 8dc2be4212dc..84db14b036e4 100644
--- a/drivers/scsi/NCR5380.h
+++ b/drivers/scsi/NCR5380.h
@@ -231,7 +231,6 @@ struct NCR5380_cmd {
 	int this_residual;
 	struct scatterlist *buffer;
 	int status;
-	int message;
 	int phase;
 	struct list_head list;
 };
-- 
2.39.5

