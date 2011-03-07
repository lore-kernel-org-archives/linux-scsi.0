From: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Subject: Re: [PATCH 3/3] tcm ibmvscsis driver
Date: Mon, 07 Mar 2011 15:24:38 +0900
Message-ID: <20110307152438C.fujita.tomonori@lab.ntt.co.jp>
References: <1297542446.29128.0.camel@mulgrave.site>
	<20110307134033K.fujita.tomonori@lab.ntt.co.jp>
	<1299478645.19683.194.camel@haakon2.linux-iscsi.org>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from tama500.ecl.ntt.co.jp ([129.60.39.148]:55157 "EHLO
	tama500.ecl.ntt.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755348Ab1CGHEa (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 7 Mar 2011 02:04:30 -0500
In-Reply-To: <1299478645.19683.194.camel@haakon2.linux-iscsi.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: nab@linux-iscsi.org
Cc: fujita.tomonori@lab.ntt.co.jp, James.Bottomley@suse.de, brking@linux.vnet.ibm.com, linux-scsi@vger.kernel.org

On Sun, 06 Mar 2011 22:17:25 -0800
"Nicholas A. Bellinger" <nab@linux-iscsi.org> wrote:

> On Mon, 2011-03-07 at 13:41 +0900, FUJITA Tomonori wrote:
> > On Sat, 12 Feb 2011 14:27:26 -0600
> > James Bottomley <James.Bottomley@suse.de> wrote:
> > 
> > > > Disregard my previous comment. It looks like current client should handle reservations
> > > > just fine without any further changes.
> > > 
> > > So is that an ack for putting this in scsi-misc ... or did you want to
> > > do more testing first?
> > 
> > Ping,
> > 
> > Brian, James, can we merge this during the next merge window?
> > 
> 
> Hi Tomo-san,
> 
> Just a heads up that I have merged the lio-core-2.6.git/tcm_ibmvscsis
> working branch into lio-4.1+master with your latest IBMVSCSIS code
> posted here:

Thanks, however, I'm not sure the inclusion of your tree automatically
means the inclusion of mainline via scsi-misc :)
