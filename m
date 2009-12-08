From: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Subject: Re: libsrp, the SRP_CMD request and additional CDB's
Date: Tue, 8 Dec 2009 16:34:47 +0900
Message-ID: <20091208163430H.fujita.tomonori@lab.ntt.co.jp>
References: <e2e108260912060207s243a018cj422f852fdf57c1cf@mail.gmail.com>
	<20091208082337J.fujita.tomonori@lab.ntt.co.jp>
	<e2e108260912072324q313234a2oda50e1bdc8373149@mail.gmail.com>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from sh.osrg.net ([192.16.179.4]:36785 "EHLO sh.osrg.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753366AbZLHHer (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 8 Dec 2009 02:34:47 -0500
In-Reply-To: <e2e108260912072324q313234a2oda50e1bdc8373149@mail.gmail.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: bart.vanassche@gmail.com
Cc: fujita.tomonori@lab.ntt.co.jp, brking@linux.vnet.ibm.com, linux-scsi@vger.kernel.org

On Tue, 8 Dec 2009 08:24:23 +0100
Bart Van Assche <bart.vanassche@gmail.com> wrote:

> >> Not ignoring the lower two bits of the add_cdb_len field would be
> >> dangerous because at least the ibmvscsi driver uses these bits as
> >> flags.
> >
> > Hmm, where does the ibmvscsi driver use these bits?
> 
> I might have confused the fields ibmvfc_cmd::add_cdb_len and
> srp_cmd::add_cdb_len.

Yeah, I think that you were mistaken. ibmvfc driver is unrelated with
SRP.

The ibmvscsi driver doesn't support large cdb so this bug doesn't
cause any real problems, I think.
