From: =?utf-8?B?SsO2cm4=?= Engel <joern@logfs.org>
Subject: Re: [PATCH v4 4/4] [SCSI] sg: push file descriptor list locking
 down to per-device locking
Date: Fri, 19 Jul 2013 17:26:37 -0400
Message-ID: <20130719212637.GD29404@logfs.org>
References: <20130715203730.GA21804@logfs.org>
 <1374075246-22923-1-git-send-email-vaughan.cao@oracle.com>
 <1374075246-22923-5-git-send-email-vaughan.cao@oracle.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1374075246-22923-5-git-send-email-vaughan.cao@oracle.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Vaughan Cao <vaughan.cao@oracle.com>
Cc: dgilbert@interlog.com, JBottomley@parallels.com, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

On Wed, 17 July 2013 23:34:06 +0800, Vaughan Cao wrote:
> Date: Wed, 17 Jul 2013 23:34:06 +0800
> From: Vaughan Cao <vaughan.cao@oracle.com>
> To: joern@logfs.org
> Cc: dgilbert@interlog.com, JBottomley@parallels.com,
> 	linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org,
> 	vaughan.cao@oracle.com
> Subject: [PATCH v4 4/4] [SCSI] sg: push file descriptor list locking =
down
>  to per-device locking
> X-Mailer: git-send-email 1.7.11.7
>=20
> Push file descriptor list locking down to per-device locking. Let sg_=
index_lock
> only protect device lookup.
> sdp->detached is also set and checked with this lock held.
>=20
> Signed-off-by: Vaughan Cao <vaughan.cao@oracle.com>

Reviewed-by: Joern Engel <joern@logfs.org>

J=C3=B6rn

--
What one programmer can do in one month, two programmers can do in two =
months.
-- Fred Brooks
