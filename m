From: Alan Cox <alan@redhat.com>
Subject: Re: PATCH: Further aacraid work
Date: Thu, 17 Jun 2004 12:46:48 -0400
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20040617164648.GA7170@devserv.devel.redhat.com>
References: <547AF3BD0F3F0B4CBDC379BAC7E4189FD2402C@otce2k03.adaptec.com> <1087484107.2090.42.camel@mulgrave> <yqujzn72uov6.fsf@chaapala-lnx2.cisco.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx1.redhat.com ([66.187.233.31]:38065 "EHLO mx1.redhat.com")
	by vger.kernel.org with ESMTP id S266570AbUFQQr6 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Thu, 17 Jun 2004 12:47:58 -0400
Content-Disposition: inline
In-Reply-To: <yqujzn72uov6.fsf@chaapala-lnx2.cisco.com>
List-Id: linux-scsi@vger.kernel.org
To: Clay Haapala <chaapala@cisco.com>
Cc: James Bottomley <James.Bottomley@steeleye.com>, "Salyzyn, Mark" <mark_salyzyn@adaptec.com>, Christoph Hellwig <hch@infradead.org>, Alan Cox <alan@redhat.com>, Linux Kernel <linux-kernel@vger.kernel.org>, SCSI Mailing List <linux-scsi@vger.kernel.org>

On Thu, Jun 17, 2004 at 11:32:29AM -0500, Clay Haapala wrote:
> So, on regular x86 this is a matter of convenience/timing, and the
> page assignments will tend toward, but not always be, random 1-page
> entries as the system is used.

In 2.4 at least it shows no sign of degenerating in that way, something
in the VM is undoing the entropy

