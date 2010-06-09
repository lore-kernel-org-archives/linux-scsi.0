From: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Subject: Re: [Open-FCoE] libfc fc_rport_recv_prli_req() changes for
	v2.6.35-rc2
Date: Wed, 09 Jun 2010 15:21:17 -0700
Message-ID: <1276122077.18353.105.camel@haakon2.linux-iscsi.org>
References: <1276120786.18353.89.camel@haakon2.linux-iscsi.org>
	 <1276121543.1431.4.camel@fritz>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp125.sbc.mail.sp1.yahoo.com ([69.147.65.184]:35158 "HELO
	smtp125.sbc.mail.sp1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1751916Ab0FIWVU (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 9 Jun 2010 18:21:20 -0400
In-Reply-To: <1276121543.1431.4.camel@fritz>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Robert Love <robert.w.love@intel.com>
Cc: Joe Eykholt <jeykholt@cisco.com>, openfcoe-devel <devel@open-fcoe.org>, linux-scsi <linux-scsi@vger.kernel.org>

On Wed, 2010-06-09 at 15:12 -0700, Robert Love wrote:
> On Wed, 2010-06-09 at 14:59 -0700, Nicholas A. Bellinger wrote:
> > Greetings Joe,
> > 
> > While doing a pull recently for v2.6.35-rc2, I ran into a merge conflict
> > below in drivers/scsi/libfc/fc_rport.c:fc_rport_recv_pril_req()
> > with the original PLOGI driven target provider hooks changes that I have
> > been including into the lio-core-2.6.git tree for tcm_fc.
> > 
> > >From taking a quick look, I assume that active and passing prov->prli()
> > calls need to appear under the new roles assignment, namely under:
> > 
> >       if (fcp_parm & FCP_SPPF_TARG_FCN)
> >               roles |= FC_RPORT_ROLE_FCP_TARGET;
> > 
> > for the upstream e44a21b726 commit.  Is there anything else that should
> > be taken into consideration to get this running again..?  
> > 
> 
> FYI, there are a bunch of rport related patches in my fcoe-next tree
> that I'll mail to linux-scsi soon. You might want to pull them or just
> be aware that they're coming. I'm not sure if they'll cause conflicts
> with your patches or not.
> 

Ok, will do..  Thanks for the heads up Robert.

Best,

--nab

