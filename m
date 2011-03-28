From: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Subject: Re: [PATCH-v2 00/14] iscsi-target: iSCSI target v4.1.0-rc1 series
	initial merge
Date: Mon, 28 Mar 2011 17:33:31 +0900
Message-ID: <20110328173331H.fujita.tomonori@lab.ntt.co.jp>
References: <1301087690.6087.126.camel@haakon2.linux-iscsi.org>
	<20110327185119V.fujita.tomonori@lab.ntt.co.jp>
	<1301301003.23175.122.camel@haakon2.linux-iscsi.org>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from tama500.ecl.ntt.co.jp ([129.60.39.148]:57830 "EHLO
	tama500.ecl.ntt.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751755Ab1C1Il2 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 28 Mar 2011 04:41:28 -0400
In-Reply-To: <1301301003.23175.122.camel@haakon2.linux-iscsi.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: nab@linux-iscsi.org
Cc: fujita.tomonori@lab.ntt.co.jp, James.Bottomley@suse.de, linux-scsi@vger.kernel.org, hch@lst.de, michaelc@cs.wisc.edu, hare@suse.de, bharrosh@panasas.com

On Mon, 28 Mar 2011 01:30:03 -0700
"Nicholas A. Bellinger" <nab@linux-iscsi.org> wrote:

> On Sun, 2011-03-27 at 19:02 +0900, FUJITA Tomonori wrote:
> > On Fri, 25 Mar 2011 14:14:50 -0700
> > "Nicholas A. Bellinger" <nab@linux-iscsi.org> wrote:
> > 
> > > What I am saying is that only the optional to implement iSCSI
> > > authentication *payloads* should have a request/response interface with
> > > userspace daemons for those types of auth libs that we always expect to
> > 
> > We don't need such interface (authentication *payloads* between kernel
> > and user spaces). All operations (including authentication) before
> > establishing a nexus should be done in userspace.
> > --
> 
> No, the interface I speak of is most definately not specific to iSCSI
> authentication payloads.
> 
> What I meant here is that iscsi-target should be sending RFC-3720
> optional authentication type specific key=value payloads into userspace
> daemon(s) using some form of acceptable mainline kernel <-> user
> interface in mainline kernel code.

The deamon can read configfs files and build the payloads.


> This interface also really needs to be 64-bit kernel / 32-bit user safe
> as well.

I'm sure that we (kernel developers) are good enough to handle it
nicely.
