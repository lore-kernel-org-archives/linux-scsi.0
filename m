From: Matthew Wilcox <matthew@wil.cx>
Subject: Re: Intel X25-M MLC SSD benchmarks
Date: Fri, 12 Dec 2008 05:15:11 -0700
Message-ID: <20081212121511.GH26095@parisc-linux.org>
References: <20081210213937.GC25548@parisc-linux.org> <83CA05F64804AF43B8F733C4ABDFAA51022D04D7@mail1.bitband.com> <311601c90812111927t54ed6a54oac3154dba30f737d@mail.gmail.com> <311601c90812112055i7ec955d6kf4fc13279817cdb0@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-ide-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <311601c90812112055i7ec955d6kf4fc13279817cdb0@mail.gmail.com>
Sender: linux-ide-owner@vger.kernel.org
To: "Eric D. Mudama" <edmudama@gmail.com>
Cc: Raz Ben-Yehuda <razb@bitband.com>, linux-ide@vger.kernel.org, linux-scsi@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

On Thu, Dec 11, 2008 at 09:55:56PM -0700, Eric D. Mudama wrote:
> On 12/11/08, Eric D. Mudama <edmudama@gmail.com> wrote:
> > Out of curiosity, is write cache enabled or disabled on these devices?
> 
> Oops, I just noticed the oflag=direct, that can have a huge
> performance difference depending on the block size.
> 
> What numbers are you getting without oflag=direct?

Without the oflag=direct option, you're measuring the performance of the
Linux page cache.  That's not very interesting.

-- 
Matthew Wilcox				Intel Open Source Technology Centre
"Bill, look, we understand that you're interested in selling us this
operating system, but compare it to ours.  We can't possibly take such
a retrograde step."
