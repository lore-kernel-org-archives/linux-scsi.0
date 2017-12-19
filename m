From: "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: Re: [trivial PATCH] treewide: Align function
	definition open/close braces
Date: Mon, 18 Dec 2017 22:31:06 -0500
Message-ID: <yq1shc7jsw5.fsf@oracle.com>
References: <1513556924.31581.51.camel@perches.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <alsa-devel-bounces@alsa-project.org>
In-Reply-To: <1513556924.31581.51.camel@perches.com> (Joe Perches's message of
 "Sun, 17 Dec 2017 16:28:44 -0800")
List-Unsubscribe: <http://mailman.alsa-project.org/mailman/options/alsa-devel>,
 <mailto:alsa-devel-request@alsa-project.org?subject=unsubscribe>
List-Archive: <http://mailman.alsa-project.org/pipermail/alsa-devel/>
List-Post: <mailto:alsa-devel@alsa-project.org>
List-Help: <mailto:alsa-devel-request@alsa-project.org?subject=help>
List-Subscribe: <http://mailman.alsa-project.org/mailman/listinfo/alsa-devel>,
 <mailto:alsa-devel-request@alsa-project.org?subject=subscribe>
Errors-To: alsa-devel-bounces@alsa-project.org
Sender: alsa-devel-bounces@alsa-project.org
To: Joe Perches <joe@perches.com>
Cc: linux-rtc@vger.kernel.org, alsa-devel@alsa-project.org, linuxppc-dev <linuxppc-dev@lists.ozlabs.org>, Jiri Kosina <trivial@kernel.org>, linux-scsi@vger.kernel.org, MPT-FusionLinux.pdl@broadcom.com, acpi4asus-user@lists.sourceforge.net, linux-wireless@vger.kernel.org, linux-kernel@vger.kernel.org, dri-devel@lists.freedesktop.org, platform-driver-x86@vger.kernel.org, linux-xfs@vger.kernel.org, linux-acpi@vger.kernel.org, linux-audit@redhat.com, amd-gfx@lists.freedesktop.org, netdev@vger.kernel.org, linux-fsdevel@vger.kernel.org, Linus Torvalds <torvalds@linux-foundation.org>, ocfs2-devel@oss.oracle.com, linux-media@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org


Joe,

> Some functions definitions have either the initial open brace and/or
> the closing brace outside of column 1.
>
> Move those braces to column 1.

SCSI bits look OK.

Acked-by: Martin K. Petersen <martin.petersen@oracle.com>

-- 
Martin K. Petersen	Oracle Linux Engineering
