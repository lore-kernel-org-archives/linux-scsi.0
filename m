From: Matthew Wilcox <matthew@wil.cx>
Subject: Re: Intel X25-M MLC SSD benchmarks
Date: Wed, 10 Dec 2008 14:39:37 -0700
Message-ID: <20081210213937.GC25548@parisc-linux.org>
References: <83CA05F64804AF43B8F733C4ABDFAA51022D04D4@mail1.bitband.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-ide-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <83CA05F64804AF43B8F733C4ABDFAA51022D04D4@mail1.bitband.com>
Sender: linux-ide-owner@vger.kernel.org
To: Raz Ben-Yehuda <razb@bitband.com>
Cc: linux-ide@vger.kernel.org, linux-scsi@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

On Wed, Dec 10, 2008 at 11:15:12PM +0200, Raz Ben-Yehuda wrote:
> Hello
> I am wondering if anyone tried Intel new disks. I benchmark them and I
> am a bit confused.
> According to the spec a single disk should provide 70MB/s write and 250
> MB/s read. Reads are ok. I am reaching this number, but writes are bad.
> With writes I am getting 20MB/s.
> I am using a dd for the test, and a deadline-line scheduler. 

What command exactly are you using, and have you tried using the no-op
elevator instead of deadline?  Also, what controller is it hooked up to?

-- 
Matthew Wilcox				Intel Open Source Technology Centre
"Bill, look, we understand that you're interested in selling us this
operating system, but compare it to ours.  We can't possibly take such
a retrograde step."
