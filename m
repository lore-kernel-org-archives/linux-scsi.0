From: Alexandre Belloni <alexandre.belloni@free-electrons.com>
Subject: Re: [trivial PATCH] treewide: Align function
 definition open/close braces
Date: Mon, 18 Dec 2017 23:15:11 +0100
Message-ID: <20171218221511.GH15162@piout.net>
References: <1513556924.31581.51.camel@perches.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <alsa-devel-bounces@alsa-project.org>
Content-Disposition: inline
In-Reply-To: <1513556924.31581.51.camel@perches.com>
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

On 17/12/2017 at 16:28:44 -0800, Joe Perches wrote:
> Some functions definitions have either the initial open brace and/or
> the closing brace outside of column 1.
> 
> Move those braces to column 1.
> 
> This allows various function analyzers like gnu complexity to work
> properly for these modified functions.
> 
> Miscellanea:
> 
> o Remove extra trailing ; and blank line from xfs_agf_verify
> 
> Signed-off-by: Joe Perches <joe@perches.com>

For RTC:

Acked-by: Alexandre Belloni <alexandre.belloni@free-electrons.com>


-- 
Alexandre Belloni, Free Electrons
Embedded Linux and Kernel engineering
http://free-electrons.com
