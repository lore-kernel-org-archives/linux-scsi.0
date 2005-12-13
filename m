From: Jens Axboe <axboe@suse.de>
Subject: Re: linux kernel panic when ejecting ieee1394 ipod
Date: Tue, 13 Dec 2005 21:54:27 +0100
Message-ID: <20051213205426.GV12024@suse.de>
References: <200512091938.jB9JbnnQ025362@einhorn.in-berlin.de> <1134168322.3491.5.camel@mulgrave> <439F3299.9020804@s5r6.in-berlin.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux1394-devel-admin@lists.sourceforge.net>
Content-Disposition: inline
In-Reply-To: <439F3299.9020804@s5r6.in-berlin.de>
Sender: linux1394-devel-admin@lists.sourceforge.net
Errors-To: linux1394-devel-admin@lists.sourceforge.net
List-Unsubscribe: <https://lists.sourceforge.net/lists/listinfo/linux1394-devel>,
	<mailto:linux1394-devel-request@lists.sourceforge.net?subject=unsubscribe>
List-Post: <mailto:linux1394-devel@lists.sourceforge.net>
List-Help: <mailto:linux1394-devel-request@lists.sourceforge.net?subject=help>
List-Subscribe: <https://lists.sourceforge.net/lists/listinfo/linux1394-devel>,
	<mailto:linux1394-devel-request@lists.sourceforge.net?subject=subscribe>
List-Archive: <http://sourceforge.net/mailarchive/forum.php?forum=linux1394-devel>
To: Stefan Richter <stefanr@s5r6.in-berlin.de>
Cc: James Bottomley <James.Bottomley@SteelEye.com>, Jody McIntyre <scjody@modernduck.com>, linux-scsi@vger.kernel.org, patmans@us.ibm.com, adq_dvb@lidskialf.net, linux1394-devel@lists.sourceforge.net
List-Id: linux-scsi@vger.kernel.org

On Tue, Dec 13 2005, Stefan Richter wrote:
> James Bottomley wrote:
> >On Fri, 2005-12-09 at 20:35 +0100, Stefan Richter wrote:
> >>When preparing a request in scsi_lib or in a SCSI high-level driver,
> >>always set a transfer direction of DMA_NONE if data length is zero,
> >>even for alleged write requests. (Extended patch derived from Jens
> >>Axboe's version.)
> [...]
> >The problem is that I already picked up Jens' patch in rc fixes, so this
> >no-longer applies.  However, given that the fix needed to be in four
> >separate places, which looks rather bad, I propose the following
> >consolidation instead.
> 
> Jens' patch alone does not fix the kernel panic AFAICS. "eject /dev/sdX" 
> goes through sd_init_command. James, could you put your patch into 
> scsi-rc-fixes too? And what about -stable?

I trust James already included his own updated version, which is
basically fixing that bug but abstracting the rq_to_scsi_dir() stuff
into a helper instead. That should fix it for all cases.

-- 
Jens Axboe



-------------------------------------------------------
This SF.net email is sponsored by: Splunk Inc. Do you grep through log files
for problems?  Stop!  Download the new AJAX search engine that makes
searching your log files as easy as surfing the  web.  DOWNLOAD SPLUNK!
http://ads.osdn.com/?ad_id=7637&alloc_id=16865&op=click
