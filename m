From: "Alastair D'Silva" <alastair@d-silva.org>
Subject: Re: [PATCH v3 0/7] Hexdump Enhancements
Date: Thu, 20 Jun 2019 11:14:06 +1000
Message-ID: <9456ca2a4ae827635bb6d864e5095a9e51f2ac45.camel@d-silva.org>
References: <20190617020430.8708-1-alastair@au1.ibm.com>
 <9a000734375c0801fc16b71f4be1235f9b857772.camel@perches.com>
 <c68cb819257f251cbb66f8998a95c31cebe2d72e.camel@d-silva.org>
 <d8316be322f33ea67640ff83f2248fe433078407.camel@perches.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <driverdev-devel-bounces@linuxdriverproject.org>
In-Reply-To: <d8316be322f33ea67640ff83f2248fe433078407.camel@perches.com>
List-Unsubscribe: <http://driverdev.linuxdriverproject.org/mailman/options/driverdev-devel>,
 <mailto:driverdev-devel-request@linuxdriverproject.org?subject=unsubscribe>
List-Archive: <http://driverdev.linuxdriverproject.org/pipermail/driverdev-devel/>
List-Post: <mailto:driverdev-devel@linuxdriverproject.org>
List-Help: <mailto:driverdev-devel-request@linuxdriverproject.org?subject=help>
List-Subscribe: <http://driverdev.linuxdriverproject.org/mailman/listinfo/driverdev-devel>,
 <mailto:driverdev-devel-request@linuxdriverproject.org?subject=subscribe>
Errors-To: driverdev-devel-bounces@linuxdriverproject.org
Sender: "devel" <driverdev-devel-bounces@linuxdriverproject.org>
To: Joe Perches <joe@perches.com>
Cc: linux-fbdev@vger.kernel.org, Stanislaw Gruszka <sgruszka@redhat.com>, Petr Mladek <pmladek@suse.com>, David Airlie <airlied@linux.ie>, Joonas Lahtinen <joonas.lahtinen@linux.intel.com>, dri-devel@lists.freedesktop.org, devel@driverdev.osuosl.org, linux-scsi@vger.kernel.org, Jassi Brar <jassisinghbrar@gmail.com>, ath10k@lists.infradead.org, intel-gfx@lists.freedesktop.org, Dan Carpenter <dan.carpenter@oracle.com>, Jose Abreu <Jose.Abreu@synopsys.com>, Tom Lendacky <thomas.lendacky@amd.com>, "James E.J. Bottomley" <jejb@linux.ibm.com>, Jani Nikula <jani.nikula@linux.intel.com>, linux-fsdevel@vger.kernel.org, Steven Rostedt <rostedt@goodmis.org>, Rodrigo Vivi <rodrigo.vivi@intel.com>, Benson Leung <bleung@chromium.org>, Kalle Valo <kvalo@codeaurora.org>, Karsten Keil <isdn@linux-pingi.de>, "Martin K. Petersen" <martin.petersen@oracle.com>, Greg Kroah-Hartman <gregkh@linuxf>
List-Id: linux-scsi@vger.kernel.org

On Wed, 2019-06-19 at 17:35 -0700, Joe Perches wrote:
> On Thu, 2019-06-20 at 09:15 +1000, Alastair D'Silva wrote:
> > On Wed, 2019-06-19 at 09:31 -0700, Joe Perches wrote:
> > > On Mon, 2019-06-17 at 12:04 +1000, Alastair D'Silva wrote:
> > > > From: Alastair D'Silva <alastair@d-silva.org>
> > > > 
> > > > Apologies for the large CC list, it's a heads up for those
> > > > responsible
> > > > for subsystems where a prototype change in generic code causes
> > > > a
> > > > change
> > > > in those subsystems.
> > > > 
> > > > This series enhances hexdump.
> > > 
> > > Still not a fan of these patches.
> > 
> > I'm afraid there's not too much action I can take on that, I'm
> > happy to
> > address specific issues though.
> > 
> > > > These improve the readability of the dumped data in certain
> > > > situations
> > > > (eg. wide terminals are available, many lines of empty bytes
> > > > exist,
> > > > etc).
> 
> I think it's generally overkill for the desired uses.

I understand where you're coming from, however, these patches make it a
lot easier to work with large chucks of binary data. I think it makes
more sense to have these patches upstream, even though committed code
may not necessarily have all the features enabled, as it means that
devs won't have to apply out-of-tree patches during development to make
larger dumps manageable.

> 
> > > Changing hexdump's last argument from bool to int is odd.
> > > 
> > 
> > Think of it as replacing a single boolean with many booleans.
> 
> I understand it.  It's odd.
> 
> I would rather not have a mixture of true, false, and apparently
> random collections of bitfields like 0xd or 0b1011 or their
> equivalent or'd defines.
> 

Where's the mixture? What would you propose instead?

-- 
Alastair D'Silva           mob: 0423 762 819
skype: alastair_dsilva    
Twitter: @EvilDeece
blog: http://alastair.d-silva.org
