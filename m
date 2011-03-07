From: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Subject: Re: [PATCH 3/3] tcm ibmvscsis driver
Date: Sun, 06 Mar 2011 22:55:41 -0800
Message-ID: <1299480941.19683.210.camel@haakon2.linux-iscsi.org>
References: <1297542446.29128.0.camel@mulgrave.site>
	 <20110307134033K.fujita.tomonori@lab.ntt.co.jp>
	 <1299478645.19683.194.camel@haakon2.linux-iscsi.org>
	 <20110307152438C.fujita.tomonori@lab.ntt.co.jp>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail.linux-iscsi.org ([67.23.28.174]:56082 "EHLO
	linux-iscsi.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752020Ab1CGHC1 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 7 Mar 2011 02:02:27 -0500
In-Reply-To: <20110307152438C.fujita.tomonori@lab.ntt.co.jp>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Cc: James.Bottomley@suse.de, brking@linux.vnet.ibm.com, linux-scsi@vger.kernel.org

On Mon, 2011-03-07 at 15:24 +0900, FUJITA Tomonori wrote:
> On Sun, 06 Mar 2011 22:17:25 -0800
> "Nicholas A. Bellinger" <nab@linux-iscsi.org> wrote:
> 
> > On Mon, 2011-03-07 at 13:41 +0900, FUJITA Tomonori wrote:
> > > On Sat, 12 Feb 2011 14:27:26 -0600
> > > James Bottomley <James.Bottomley@suse.de> wrote:
> > > 
> > > > > Disregard my previous comment. It looks like current client should handle reservations
> > > > > just fine without any further changes.
> > > > 
> > > > So is that an ack for putting this in scsi-misc ... or did you want to
> > > > do more testing first?
> > > 
> > > Ping,
> > > 
> > > Brian, James, can we merge this during the next merge window?
> > > 
> > 
> > Hi Tomo-san,
> > 
> > Just a heads up that I have merged the lio-core-2.6.git/tcm_ibmvscsis
> > working branch into lio-4.1+master with your latest IBMVSCSIS code
> > posted here:
> 
> Thanks, however, I'm not sure the inclusion of your tree automatically
> means the inclusion of mainline via scsi-misc :)

Unfortuately not, but having IBMVSCSIS included into the main LIO
upstream branch is a good way to ensure a fabric module will stay
current against the latest target code.  ;)

So at this point (for Brian and James) I am happy enough with the
current state of things to give my ack for-39 mainline.

Acked-by: Nicholas A. Bellinger <nab@linux-iscsi.org>

Thanks Tomo!

--nab

