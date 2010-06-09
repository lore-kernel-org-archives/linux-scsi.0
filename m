From: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Subject: Re: libfc fc_rport_recv_prli_req() changes for v2.6.35-rc2
Date: Wed, 09 Jun 2010 15:28:17 -0700
Message-ID: <1276122497.18353.110.camel@haakon2.linux-iscsi.org>
References: <1276120786.18353.89.camel@haakon2.linux-iscsi.org>
	 <4C10144B.9040703@cisco.com>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp127.sbc.mail.sp1.yahoo.com ([69.147.65.186]:24763 "HELO
	smtp127.sbc.mail.sp1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1755717Ab0FIW2T (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 9 Jun 2010 18:28:19 -0400
In-Reply-To: <4C10144B.9040703@cisco.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Joe Eykholt <jeykholt@cisco.com>
Cc: openfcoe-devel <devel@open-fcoe.org>, linux-scsi <linux-scsi@vger.kernel.org>, "Love, Robert W" <robert.w.love@intel.com>

On Wed, 2010-06-09 at 15:23 -0700, Joe Eykholt wrote:
> On 6/9/10 2:59 PM, Nicholas A. Bellinger wrote:
> > Greetings Joe,
> >
> > While doing a pull recently for v2.6.35-rc2, I ran into a merge conflict
> > below in drivers/scsi/libfc/fc_rport.c:fc_rport_recv_pril_req()
> > with the original PLOGI driven target provider hooks changes that I have
> > been including into the lio-core-2.6.git tree for tcm_fc.
> >
> >> From taking a quick look, I assume that active and passing prov->prli()
> > calls need to appear under the new roles assignment, namely under:
> >
> >        if (fcp_parm&  FCP_SPPF_TARG_FCN)
> >                roles |= FC_RPORT_ROLE_FCP_TARGET;
> >
> > for the upstream e44a21b726 commit.  Is there anything else that should
> > be taken into consideration to get this running again..?
> 
> Most of the code in the HEAD version is right.
> 
> Just add the two lines initializing the roles to unknown
> to the version above the ==== separator and then keep that version.
> 
> The provider prli() functions will take care of the roles.
> 

Ok, I will add the initial unknown role assignment to HEAD and make a
quick test run shortly.

Thanks for your comments!

Best,

--nab


