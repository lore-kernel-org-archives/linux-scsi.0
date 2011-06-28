From: "Bhanu Prakash Gollapudi" <bprakash-dY08KVG/lbpWk0Htik3J/w@public.gmane.org>
Subject: [PATCH 08/12] bnx2fc: Enable support for sequence level
 error recovery
Date: Mon, 27 Jun 2011 23:31:00 -0700
Message-ID: <1309242664-27252-9-git-send-email-bprakash@broadcom.com>
References: <1309242664-27252-1-git-send-email-bprakash@broadcom.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <devel-bounces-s9riP+hp16TNLxjTenLetw@public.gmane.org>
In-Reply-To: <1309242664-27252-1-git-send-email-bprakash-dY08KVG/lbpWk0Htik3J/w@public.gmane.org>
List-Unsubscribe: <https://lists.open-fcoe.org/mailman/options/devel>,
	<mailto:devel-request-s9riP+hp16TNLxjTenLetw@public.gmane.org?subject=unsubscribe>
List-Archive: <https://lists.open-fcoe.org/pipermail/devel>
List-Post: <mailto:devel-s9riP+hp16TNLxjTenLetw@public.gmane.org>
List-Help: <mailto:devel-request-s9riP+hp16TNLxjTenLetw@public.gmane.org?subject=help>
List-Subscribe: <https://lists.open-fcoe.org/mailman/listinfo/devel>,
	<mailto:devel-request-s9riP+hp16TNLxjTenLetw@public.gmane.org?subject=subscribe>
Sender: devel-bounces-s9riP+hp16TNLxjTenLetw@public.gmane.org
Errors-To: devel-bounces-s9riP+hp16TNLxjTenLetw@public.gmane.org
To: JBottomley-bzQdu9zFT3WakBO8gow8eQ@public.gmane.org, linux-scsi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: devel-s9riP+hp16TNLxjTenLetw@public.gmane.org
List-Id: linux-scsi@vger.kernel.org

Driver advertises its support for 'retry' bit and 'conf completion' bit in PRLI
params to enable support for 'sequence level error recovery'

Signed-off-by: Bhanu Prakash Gollapudi <bprakash-dY08KVG/lbpWk0Htik3J/w@public.gmane.org>
---
 drivers/scsi/bnx2fc/bnx2fc_fcoe.c |    3 ---
 1 files changed, 0 insertions(+), 3 deletions(-)

diff --git a/drivers/scsi/bnx2fc/bnx2fc_fcoe.c b/drivers/scsi/bnx2fc/bnx2fc_fcoe.c
index 343b7e7..bb17634 100644
--- a/drivers/scsi/bnx2fc/bnx2fc_fcoe.c
+++ b/drivers/scsi/bnx2fc/bnx2fc_fcoe.c
@@ -899,11 +899,8 @@ static int bnx2fc_lport_config(struct fc_lport *lport)
 	lport->e_d_tov = 2 * 1000;
 	lport->r_a_tov = 10 * 1000;
 
-	/* REVISIT: enable when supporting tape devices
 	lport->service_params = (FCP_SPPF_INIT_FCN | FCP_SPPF_RD_XRDY_DIS |
 				FCP_SPPF_RETRY | FCP_SPPF_CONF_COMPL);
-	*/
-	lport->service_params = (FCP_SPPF_INIT_FCN | FCP_SPPF_RD_XRDY_DIS);
 	lport->does_npiv = 1;
 
 	memset(&lport->rnid_gen, 0, sizeof(struct fc_els_rnid_gen));
-- 
1.7.0.6
