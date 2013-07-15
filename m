From: =?utf-8?B?SsO2cm4=?= Engel <joern@logfs.org>
Subject: Re: [PATCH v2 1/1] [SCSI] sg: fix race condition when do exclusive
 open
Date: Mon, 15 Jul 2013 13:25:46 -0400
Message-ID: <20130715172545.GA20517@logfs.org>
References: <51AF0269.9070900@oracle.com>
 <20130605132746.GA1690@logfs.org>
 <51AF646D.7030903@oracle.com>
 <20130605154106.GA2737@logfs.org>
 <51BF0ADD.1080604@oracle.com>
 <20130705173953.GA15089@logfs.org>
 <51D852DC.4070808@oracle.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <51D852DC.4070808@oracle.com>
Sender: linux-kernel-owner@vger.kernel.org
To: vaughan <vaughan.cao@oracle.com>
Cc: dgilbert@interlog.com, JBottomley@parallels.com, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

On Sun, 7 July 2013 01:24:44 +0800, vaughan wrote:
>=20
> Do you agree that I use a per device spin_lock 'sfd_lock' to protect
> sfds list and leave sg_index_lock
> only protect the global sg device lookup? I think it's reasonable
> for concurrency.

That bit looks fine to me.  I don't think it matters much, but sure,
why not!

J=C3=B6rn

--
One of the painful things about our time is that those who feel certain=
ty
are stupid, and those with any imagination and understanding are filled
with doubt and indecision.
-- Bertrand Russell
