From: Christoph Hellwig <hch@infradead.org>
Subject: Re: replace deprecated hosts.h file
Date: Sun, 30 May 2004 09:46:45 +0100
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20040530084645.GA29411@infradead.org>
References: <20040529142126.GA31365@devserv.devel.redhat.com> <40B8A7FA.8070802@pobox.com> <20040529151431.GD31365@devserv.devel.redhat.com> <40B8B383.4050602@pobox.com> <20040529164056.GH31365@devserv.devel.redhat.com> <1085880986.18642.351.camel@compaq.xsintricity.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from [213.146.154.40] ([213.146.154.40]:43207 "EHLO
	pentafluge.infradead.org") by vger.kernel.org with ESMTP
	id S261932AbUE3Iqt (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Sun, 30 May 2004 04:46:49 -0400
Content-Disposition: inline
In-Reply-To: <1085880986.18642.351.camel@compaq.xsintricity.com>
List-Id: linux-scsi@vger.kernel.org
To: Doug Ledford <dledford@redhat.com>
Cc: Arjan Van de Ven <arjanv@redhat.com>, Jeff Garzik <jgarzik@pobox.com>, linux-scsi mailing list <linux-scsi@vger.kernel.org>, James Bottomley <James.Bottomley@steeleye.com>

On Sat, May 29, 2004 at 09:36:26PM -0400, Doug Ledford wrote:
> core kernel code == specifically tied to kernel major/minor
> hardware driver code != tied to kernel major/minor

In Linux it in fact is.  Especially when the subsystem has big changes
like scsi in the 2.4->2.6 transition.  We need to clean out the letovers,
and we want to finish that in early 2.7.  Getting these changes in earlier
tends to make life much easier, but I'll do another pass once 2.7 is out -
if a maintainer wants to reject those changes then his driver will simply
break.
