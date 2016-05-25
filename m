From: Joe Perches <joe@perches.com>
Subject: Re: [PATCH 3/3] ibmvscsis: clean up functions
Date: Wed, 25 May 2016 07:44:39 -0700
Message-ID: <1464187479.16344.14.camel@perches.com>
References: <1464097978-88457-1-git-send-email-bryantly@linux.vnet.ibm.com>
	 <1464185854-19761-1-git-send-email-bryantly@linux.vnet.ibm.com>
	 <1464185854-19761-3-git-send-email-bryantly@linux.vnet.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1464185854-19761-3-git-send-email-bryantly@linux.vnet.ibm.com>
Sender: linux-kernel-owner@vger.kernel.org
To: "Bryant G. Ly" <bryantly@linux.vnet.ibm.com>, tyreld@linux.vnet.ibm.com, bart.vanassche@sandisk.com
Cc: martin.petersen@oracle.com, akpm@linux-foundation.org, kvalo@codeaurora.org, davem@davemloft.net, mchehab@osg.samsung.com, jslaby@suse.com, bp@suse.de, linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org, target-devel@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

On Wed, 2016-05-25 at 09:17 -0500, Bryant G. Ly wrote:
> From: bryantly <bryantly@linux.vnet.ibm.com>

Please use your whole name here and for your sign-off like:

=46rom: Bryant G. Ly <bryantly@linux.vnet.ibm.com>
Signed-off-by: Bryant G. Ly <bryantly@linux.vnet.ibm.com>

> This patch removes forward declarations and re-organizes the
> functions within the driver. This patch also fixes MAINTAINERS
> for ibmvscsis.

trivial note:

> diff --git a/drivers/scsi/ibmvscsi/ibmvscsis.c b/drivers/scsi/ibmvscs=
i/ibmvscsis.c
[]
> =A0static inline long h_copy_rdma(s64 length, u64 sliobn, u64 slioba,
> =A0			=A0=A0=A0=A0=A0=A0=A0u64 dliobn, u64 dlioba)
> =A0{
>=20

=46unctions like this would be less indented and less
line wrapped for 80 columns if they were written:

	if (!se_cmd->residual_count)
		return;

	[unindented one level...]

etc...
