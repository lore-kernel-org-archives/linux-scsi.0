From: Lars Marowsky-Bree <lmb@suse.de>
Subject: Re: [dm-devel] Re: [ANNOUNCE] multipath-tools-0.3.4
Date: Mon, 25 Oct 2004 23:03:04 +0200
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20041025210304.GH3714@marowsky-bree.de>
References: <1096071849.4466.31.camel@zezette> <1097054573.4163b96d1262c@imp5-q.free.fr> <1097495416.416a73787e0ae@imp1-q.free.fr> <1098021787.5433.8.camel@zezette> <1098269169.417641f18a234@imp1-q.free.fr> <1098656088.9350.88.camel@zezette> <1098692559.2798.7.camel@laptop.fenrus.org> <1098697123.417cc9a3b5bc5@imp1-q.free.fr>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from gate.in-addr.de ([212.8.193.158]:4062 "EHLO mx.in-addr.de")
	by vger.kernel.org with ESMTP id S262207AbUJZLCN (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Tue, 26 Oct 2004 07:02:13 -0400
Content-Disposition: inline
In-Reply-To: <1098697123.417cc9a3b5bc5@imp1-q.free.fr>
List-Id: linux-scsi@vger.kernel.org
To: device-mapper development <dm-devel@redhat.com>, Arjan van de Ven <arjan@infradead.org>
Cc: "linux-raid@vger.kernel.org" <linux-raid@vger.kernel.org>, "linux-hotplug-devel@lists.sourceforge.net" <linux-hotplug-devel@lists.sourceforge.net>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>

On 2004-10-25T11:38:43, christophe.varoqui@free.fr wrote:

> In fact all the sg stuff I use is done with the SG_IO ioctl (see
> libcheckers/*.c) But somehow, it doesn't work as expected. I don't
> remember how exactly it failed in my tests but it did ... I remembere=
d
> receiving bad path status and experiencing blocked checkers.

Can you please clarify the error you saw? I didn't experience that yet
with the SG_IO ioctl().


Sincerely,
    Lars Marowsky-Br=E9e <lmb@suse.de>

--=20
High Availability & Clustering
SUSE Labs, Research and Development
SUSE LINUX AG - A Novell company

-
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
