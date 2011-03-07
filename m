From: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Subject: Re: [PATCH 3/3] tcm ibmvscsis driver
Date: Sun, 06 Mar 2011 22:17:25 -0800
Message-ID: <1299478645.19683.194.camel@haakon2.linux-iscsi.org>
References: <1297366739.18212.182.camel@haakon2.linux-iscsi.org>
	 <4D55A684.9060208@linux.vnet.ibm.com>
	 <1297542446.29128.0.camel@mulgrave.site>
	 <20110307134033K.fujita.tomonori@lab.ntt.co.jp>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail.linux-iscsi.org ([67.23.28.174]:48019 "EHLO
	linux-iscsi.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750862Ab1CGGYL (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 7 Mar 2011 01:24:11 -0500
In-Reply-To: <20110307134033K.fujita.tomonori@lab.ntt.co.jp>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Cc: James.Bottomley@suse.de, brking@linux.vnet.ibm.com, linux-scsi@vger.kernel.org

On Mon, 2011-03-07 at 13:41 +0900, FUJITA Tomonori wrote:
> On Sat, 12 Feb 2011 14:27:26 -0600
> James Bottomley <James.Bottomley@suse.de> wrote:
> 
> > > Disregard my previous comment. It looks like current client should handle reservations
> > > just fine without any further changes.
> > 
> > So is that an ack for putting this in scsi-misc ... or did you want to
> > do more testing first?
> 
> Ping,
> 
> Brian, James, can we merge this during the next merge window?
> 

Hi Tomo-san,

Just a heads up that I have merged the lio-core-2.6.git/tcm_ibmvscsis
working branch into lio-4.1+master with your latest IBMVSCSIS code
posted here:

[PATCH 0/3] ibmvscsis driver rewrite
http://marc.info/?l=linux-scsi&m=129734085306633&w=2

At this point there is only one minor change to update parameter usage
of tcm_queuecommand() -> transport_get_lun_for_cmd() for lio-4.1 that
has been pushed here:

commit 39d42814c54de74ab8bf1a59b90331a337a89cd3
Author: Nicholas Bellinger <nab@linux-iscsi.org>
Date:   Mon Mar 7 06:12:33 2011 +0000

    ibmvscsis: Update transport_get_lun_for_cmd() usage for lio-4.1

The patch to change transport_get_lun_for_cmd() parameter usage has not
been submitted for-39 mainline yet, so please ignore this minor patch
for the merge of IBMVSCSIS against mainline v4.0 target code.

Please let me know if you have any more updates to be included in the
working tree.

Thank you!

--nab


