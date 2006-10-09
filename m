From: Henne <henne@nachtwindheim.de>
Subject: Re: [PATCH] scsi: Scsi_Cmnd convertion in aic7xxx_old.c
Date: Mon, 09 Oct 2006 15:38:34 +0200
Message-ID: <452A50DA.102@nachtwindheim.de>
References: <452363DB.60107@nachtwindheim.de> <20061006202913.GA7835@aepfle.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner+glk-linux-kernel-3=40m.gmane.org-S932815AbWJINh7@vger.kernel.org>
In-Reply-To: <20061006202913.GA7835@aepfle.de>
Sender: linux-kernel-owner@vger.kernel.org
To: Olaf Hering <olaf@aepfle.de>
Cc: Andrew Morton <akpm@osdl.org>, James Bottomley <James.Bottomley@SteelEye.com>, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

Fixes a typo in the aic7xxx_old.c.
Signed-off-by: Olaf Hering <olaf@aepfle.de>
Signed-off-by: Henrik Kretzschmar <henne@nachtwindheim.de>

---
Damn!
Thanks Olaf!

diff --git a/drivers/scsi/aic7xxx_old.c b/drivers/scsi/aic7xxx_old.c
index 7f0adf9..d9cc3fe 100644
--- a/drivers/scsi/aic7xxx_old.c
+++ b/drivers/scsi/aic7xxx_old.c
@@ -2646,7 +2646,7 @@ static void aic7xxx_done_cmds_complete(s
 
 	while (p->completeq.head != NULL) {
 		cmd = p->completeq.head;
-		p->completeq.head = (struct scsi_Cmnd *) cmd->host_scribble;
+		p->completeq.head = (struct scsi_cmnd *) cmd->host_scribble;
 		cmd->host_scribble = NULL;
 		cmd->scsi_done(cmd);
 	}
