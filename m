From: "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: Re: [PATCH] [SCSI] st: Remove obsolete scsi_tape.max_pfn
Date: Wed, 18 Nov 2015 12:00:31 -0500
Message-ID: <yq17flfs0nk.fsf@sermon.lab.mkp.net>
References: <1447588113-21117-1-git-send-email-geert@linux-m68k.org>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1447588113-21117-1-git-send-email-geert@linux-m68k.org> (Geert
	Uytterhoeven's message of "Sun, 15 Nov 2015 12:48:33 +0100")
Sender: linux-kernel-owner@vger.kernel.org
To: Geert Uytterhoeven <geert@linux-m68k.org>
Cc: Kai =?utf-8?Q?M=C3=A4kisara?= <Kai.Makisara@kolumbus.fi>, "James E.J. Bottomley" <JBottomley@odin.com>, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, "Ewan D. Milne" <emilne@redhat.com>
List-Id: linux-scsi@vger.kernel.org

>>>>> "Geert" == Geert Uytterhoeven <geert@linux-m68k.org> writes:

Geert> Its last user was removed 10 years ago, in commit
Geert> 8b05b773b6030de5 ("[SCSI] convert st to use scsi_execute_async").

Applied to the 4.5 queue.

-- 
Martin K. Petersen	Oracle Linux Engineering
