From: =?utf-8?B?SsO2cm4=?= Engel <joern@logfs.org>
Subject: Re: [PATCH v4 2/4] [SCSI] sg: no need sg_open_exclusive_lock
Date: Fri, 19 Jul 2013 17:19:29 -0400
Message-ID: <20130719211929.GB29404@logfs.org>
References: <20130715203730.GA21804@logfs.org>
 <1374075246-22923-1-git-send-email-vaughan.cao@oracle.com>
 <1374075246-22923-3-git-send-email-vaughan.cao@oracle.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1374075246-22923-3-git-send-email-vaughan.cao@oracle.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Vaughan Cao <vaughan.cao@oracle.com>
Cc: dgilbert@interlog.com, JBottomley@parallels.com, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

On Wed, 17 July 2013 23:34:04 +0800, Vaughan Cao wrote:
> Date: Wed, 17 Jul 2013 23:34:04 +0800
> From: Vaughan Cao <vaughan.cao@oracle.com>
> To: joern@logfs.org
> Cc: dgilbert@interlog.com, JBottomley@parallels.com,
> 	linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org,
> 	vaughan.cao@oracle.com
> Subject: [PATCH v4 2/4] [SCSI] sg: no need sg_open_exclusive_lock
> X-Mailer: git-send-email 1.7.11.7
>=20
> Open exclusive check is protected by o_sem, no need sg_open_exclusive=
_lock.
> @exclude is used to record which type of rwsem we are holding.
>=20
> Signed-off-by: Vaughan Cao <vaughan.cao@oracle.com>
Reviewed-by: Joern Engel <joern@logfs.org>

J=C3=B6rn

--
"Error protection by error detection and correction."
-- from a university class
