From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH] scsi: pm8001: pm8001_hwi.c:  Fix for possible null
 pointer dereference
Date: Wed, 28 May 2014 04:28:11 -0700
Message-ID: <20140528112811.GD11953@infradead.org>
References: <1400429640-11489-1-git-send-email-rickard_strandqvist@spectrumdigital.se>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1400429640-11489-1-git-send-email-rickard_strandqvist@spectrumdigital.se>
Sender: linux-kernel-owner@vger.kernel.org
To: Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se>
Cc: xjtuwjp@gmail.com, lindar_liu@usish.com, "James E.J. Bottomley" <JBottomley@parallels.com>, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

On Sun, May 18, 2014 at 06:14:00PM +0200, Rickard Strandqvist wrote:
> There is otherwise a risk of a possible null pointer dereference.
> 
> Was largely found by using a static code analysis program called cppcheck.

I can't see how dev->lldd_dev would be NULL here.
