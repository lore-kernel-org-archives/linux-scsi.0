From: Al Viro <viro@ZenIV.linux.org.uk>
Subject: Re: [PATCH -next 2/2] sun3_scsi: switch to ->show_info()
Date: Sat, 4 May 2013 19:51:17 +0100
Message-ID: <20130504185117.GF25399@ZenIV.linux.org.uk>
References: <1365594729-25759-1-git-send-email-geert@linux-m68k.org>
 <1365594729-25759-2-git-send-email-geert@linux-m68k.org>
 <CAMuHMdWEMT8FWaByiBh+Y2qhwWyqT4JyVZmLsCEYv30v2qM4yg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-next-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <CAMuHMdWEMT8FWaByiBh+Y2qhwWyqT4JyVZmLsCEYv30v2qM4yg@mail.gmail.com>
Sender: linux-next-owner@vger.kernel.org
To: Geert Uytterhoeven <geert@linux-m68k.org>
Cc: Sam Creasey <sammy@sammy.net>, scsi <linux-scsi@vger.kernel.org>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, Linux-Next <linux-next@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org

On Fri, May 03, 2013 at 10:03:43PM +0200, Geert Uytterhoeven wrote:
> Ping?
> 
> Now the build failure is also in Linus' tree:
> 
> http://kisskb.ellerman.id.au/kisskb/buildresult/8674437/
> 
> BTW, this patch depends on "[PATCH 1/2] sun3_scsi: Fill in missing
> scsi_host_template.proc_info method"

Collapsed together and applied, will go out today
