From: Christoph Hellwig <hch@infradead.org>
Subject: Re: Conversion to generic boolean
Date: Tue, 29 Aug 2006 12:41:43 +0100
Message-ID: <20060829114143.GB4076@infradead.org>
References: <44EFBEFA.2010707@student.ltu.se> <20060828093202.GC8980@infradead.org> <Pine.LNX.4.61.0608281255100.14305@yvahk01.tjqt.qr> <44F2DEDC.3020608@student.ltu.se> <1156792540.2367.2.camel@entropy>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner+glk-linux-kernel-3=40m.gmane.org-S964947AbWH2LmM@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1156792540.2367.2.camel@entropy>
Sender: linux-kernel-owner@vger.kernel.org
To: Nicholas Miell <nmiell@comcast.net>
Cc: Richard Knutsson <ricknu-0@student.ltu.se>, Jan Engelhardt <jengelh@linux01.gwdg.de>, Christoph Hellwig <hch@infradead.org>, James.Bottomley@SteelEye.com, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

On Mon, Aug 28, 2006 at 12:15:40PM -0700, Nicholas Miell wrote:
> > That is error-prone. Not "==FALSE" but what happens if x is (for some 
> > reason) not 1 and then "if (x==TRUE)".
> 
> If you're using _Bool, that isn't possible. (Except at the boundaries
> where you have to validate untrusted data -- and the compiler makes that
> more difficult, because it "knows" that a _Bool can only be 0 or 1 and
> therefore your check to see if it's not 0 or 1 can "safely" be
> eliminated.)

gcc lets you happily assign any integer value to bool/_Bool, so unless
you write sparse support for actually checking things there's not the
slightest advantage in value range checking.
