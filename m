From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH] scsi: mvsas: mv_sas.c:  Fix for possible null pointer
 dereference
Date: Wed, 28 May 2014 04:27:21 -0700
Message-ID: <20140528112721.GC11953@infradead.org>
References: <1400429547-11342-1-git-send-email-rickard_strandqvist@spectrumdigital.se>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1400429547-11342-1-git-send-email-rickard_strandqvist@spectrumdigital.se>
Sender: linux-kernel-owner@vger.kernel.org
To: Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se>
Cc: "James E.J. Bottomley" <JBottomley@parallels.com>, Jiri Kosina <jkosina@suse.cz>, Randy Dunlap <rdunlap@infradead.org>, Masanari Iida <standby24x7@gmail.com>, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

On Sun, May 18, 2014 at 06:12:26PM +0200, Rickard Strandqvist wrote:
> There is otherwise a risk of a possible null pointer dereference.
> 
> Was largely found by using a static code analysis program called cppcheck.
> 
> Signed-off-by: Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se>

Looks good, although I'd love to know how a NULL dev could even happen
here.

Reviewed-by: Christoph Hellwig <hch@lst.de>
