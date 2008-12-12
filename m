From: "Eric D. Mudama" <edmudama@gmail.com>
Subject: Re: Intel X25-M MLC SSD benchmarks
Date: Fri, 12 Dec 2008 07:25:18 -0700
Message-ID: <311601c90812120625o4e000646u98aebc8ab3556a33@mail.gmail.com>
References: <20081210213937.GC25548@parisc-linux.org>
	 <83CA05F64804AF43B8F733C4ABDFAA51022D04D7@mail1.bitband.com>
	 <311601c90812111927t54ed6a54oac3154dba30f737d@mail.gmail.com>
	 <311601c90812112055i7ec955d6kf4fc13279817cdb0@mail.gmail.com>
	 <e2e108260812112315q5ed1d265q86cf22b1dd59c69d@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-ide-owner@vger.kernel.org>
In-Reply-To: <e2e108260812112315q5ed1d265q86cf22b1dd59c69d@mail.gmail.com>
Content-Disposition: inline
Sender: linux-ide-owner@vger.kernel.org
To: Bart Van Assche <bart.vanassche@gmail.com>
Cc: Raz Ben-Yehuda <razb@bitband.com>, Matthew Wilcox <matthew@wil.cx>, linux-ide@vger.kernel.org, linux-scsi@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

On Fri, Dec 12, 2008 at 12:15 AM, Bart Van Assche
<bart.vanassche@gmail.com> wrote:
>
> On Fri, Dec 12, 2008 at 5:55 AM, Eric D. Mudama <edmudama@gmail.com> wrote:
> > On 12/11/08, Eric D. Mudama <edmudama@gmail.com> wrote:
> >> Out of curiosity, is write cache enabled or disabled on these devices?
> >
> > Oops, I just noticed the oflag=direct, that can have a huge
> > performance difference depending on the block size.
> >
> > What numbers are you getting without oflag=direct?
>
> IMHO repeating the measurements without oflag=direct does not make
> sense: measurements with oflag=direct tell something about the
> performance of the SSD and the software layers on top of it. Without
> oflag=direct writes are buffered by Linux and data is written
> asynchronously to the SSD.

Oops, I guess I assumed that by writing a few gigabytes of data it
wouldn't matter that much.  I'll run the test again in a bit once I'm
off this solaris machine.
