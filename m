From: Matthew Wilcox <willy@debian.org>
Subject: Re: CONFIG_SCSI_SYM53C8XX_IOMAPPED
Date: Thu, 16 Sep 2004 15:13:23 +0100
Sender: <willy@www.linux.org.uk>
Message-ID: <20040916141323.GL642@parcelfarce.linux.theplanet.co.uk>
References: <hhsm9iv8ws.fsf@alsvidh.mathematik.uni-muenchen.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <bounce-debian-kernel=glddk-debian-kernel=m.gmane.org@lists.debian.org>
Content-Disposition: inline
In-Reply-To: <hhsm9iv8ws.fsf@alsvidh.mathematik.uni-muenchen.de>
Resent-Message-ID: <8FnU_C.A.sdH.G-ZSBB@murphy>
List-Post: <mailto:debian-kernel@lists.debian.org>
List-Help: <mailto:debian-kernel-request@lists.debian.org?subject=help>
List-Subscribe: <mailto:debian-kernel-request@lists.debian.org?subject=subscribe>
List-Unsubscribe: <mailto:debian-kernel-request@lists.debian.org?subject=unsubscribe>
List-Archive: <http://lists.debian.org/debian-kernel/>
To: debian-kernel@lists.debian.org
Cc: linux-scsi@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

On Thu, Sep 16, 2004 at 11:51:31AM +0200, Jens Schmalzing wrote:
> I recently encountered a machine (a Thinkpad 860) with a NCR 53C810
> SCSI controller that would not work properly unless the config option
> CONFIG_SCSI_SYM53C8XX_IOMAPPED was set.  Under these circumstances,
> installation was a royal pain in the ass, and therefore, I am inclined
> to trade performance for wider support and enable this in the PowerPC
> kernel image packages.
> 
> Any comments?

I was hoping nobody needed to set this option.  It has worse performance,
plus it needs to be enabled on some platforms, like SGI's Visual
Workstation which has completely shafted io port accesses.  As upstream
maintainer, I'd like more information about it please ...

 - How does it "not work properly"?  Does it hang on first access to
   the chip, or does it suffer data corruption?
 - Are the io memory resources on this Thinkpad properly programmed?
 - What kernel were you trying, 2.4 or 2.6?

-- 
"Next the statesmen will invent cheap lies, putting the blame upon 
the nation that is attacked, and every man will be glad of those
conscience-soothing falsities, and will diligently study them, and refuse
to examine any refutations of them; and thus he will by and by convince 
himself that the war is just, and will thank God for the better sleep 
he enjoys after this process of grotesque self-deception." -- Mark Twain
