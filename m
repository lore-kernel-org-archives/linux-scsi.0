From: Paul Bolle <pebolle@tiscali.nl>
Subject: Re: [PATCH] drivers/scsi/arm/acornscsi.c: rename
 CONFIG_ACORNSCSI_CONSTANTS
Date: Tue, 28 Apr 2015 21:34:42 +0200
Message-ID: <1430249682.2411.79.camel@x220>
References: <1430230511-10869-1-git-send-email-valentinrothberg@gmail.com>
	 <1430248224.2411.68.camel@x220>
	 <CAD3Xx4LMZudtWBajjpNgLjXbCKmiAq9YyMZwMNn=5=5w_1vCPQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <CAD3Xx4LMZudtWBajjpNgLjXbCKmiAq9YyMZwMNn=5=5w_1vCPQ@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Valentin Rothberg <valentinrothberg@gmail.com>
Cc: JBottomley@odin.com, linux@arm.linux.org.uk, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

Hi Valentin,

On Tue, 2015-04-28 at 21:26 +0200, Valentin Rothberg wrote:
> On Tue, Apr 28, 2015 at 9:10 PM, Paul Bolle <pebolle@tiscali.nl> wrote:
> > Will the Erlangen bot still spot ACORNSCSI_CONSTANTS as a potential
> > issue?
> 
> No, undertaker-checkpatch won't complain about this.  There are
> thousands of such cases (i.e., without CONFIG_ prefix) around in the
> code (mostly #ifdef DEBUG).  But most of them are intentionally dead
> or related to debugging, so they are ignored to avoid having false
> positives.

Well, in a few years time, once undertaker-checkpatch has stomped out
most of the faux Kconfig preprocessor checks, that might be an area to
cover too. Or is that issue, ie pointless preprocessor checks, harder
than one might naively think?

Thanks,


Paul Bolle
