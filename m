From: Joe Perches <joe@perches.com>
Subject: Re: [PATCH v2] scsi: bnx2i: bnx2i_iscsi.c:  Cleaning up variable is
 set more than once
Date: Thu, 26 Jun 2014 05:17:55 -0700
Message-ID: <1403785075.7977.46.camel@joe-AO725>
References: <1403783689-10457-1-git-send-email-rickard_strandqvist@spectrumdigital.se>
	 <1403784303.7977.38.camel@joe-AO725> <53AC0E2A.4040907@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <53AC0E2A.4040907@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Maurizio Lombardi <mlombard@redhat.com>
Cc: Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se>, Eddie Wai <eddie.wai@broadcom.com>, "James E.J. Bottomley" <JBottomley@parallels.com>, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

On Thu, 2014-06-26 at 14:12 +0200, Maurizio Lombardi wrote:
> 
> On 06/26/2014 02:05 PM, Joe Perches wrote:
> > On Thu, 2014-06-26 at 13:54 +0200, Rickard Strandqvist wrote:
> >> A struct member variable is set to different values without having used in between.
> > []
> >> diff --git a/drivers/scsi/bnx2i/bnx2i_iscsi.c b/drivers/scsi/bnx2i/bnx2i_iscsi.c
> > []
> >> @@ -1643,12 +1643,11 @@ static void bnx2i_conn_get_stats(struct iscsi_cls_conn *cls_conn,
> >>  	stats->r2t_pdus = conn->r2t_pdus_cnt;
> >>  	stats->tmfcmd_pdus = conn->tmfcmd_pdus_cnt;
> >>  	stats->tmfrsp_pdus = conn->tmfrsp_pdus_cnt;
> >> -	stats->custom_length = 3;
> >>  	strcpy(stats->custom[2].desc, "eh_abort_cnt");
> >>  	stats->custom[2].value = conn->eh_abort_cnt;
> >>  	stats->digest_err = 0;
> >>  	stats->timeout_err = 0;
> >> -	stats->custom_length = 0;
> >> +	stats->custom_length = 3;
> > 
> > You are changing custom_length from 0 to 3.
> > 
> > Why is this correct?
> 
> http://marc.info/?l=linux-scsi&m=140371670511706&w=2

Then the subject and commit message are wrong and need
to be updated to reflect your text.

This is a bugfix, not a cleanup.
