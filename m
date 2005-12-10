From: Stefan Richter <stefanr@s5r6.in-berlin.de>
Subject: Re: linux kernel panic when ejecting ieee1394 ipod
Date: Sat, 10 Dec 2005 11:55:34 +0100
Message-ID: <439AB426.1060106@s5r6.in-berlin.de>
References: <4399CF7B.7060708@s5r6.in-berlin.de> <200512091938.jB9JbnnQ025362@einhorn.in-berlin.de> <20051210084832.GS26185@suse.de> <20051210092827.GA4356@infradead.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux1394-devel-admin@lists.sourceforge.net>
In-Reply-To: <20051210092827.GA4356@infradead.org>
Sender: linux1394-devel-admin@lists.sourceforge.net
Errors-To: linux1394-devel-admin@lists.sourceforge.net
List-Unsubscribe: <https://lists.sourceforge.net/lists/listinfo/linux1394-devel>,
	<mailto:linux1394-devel-request@lists.sourceforge.net?subject=unsubscribe>
List-Post: <mailto:linux1394-devel@lists.sourceforge.net>
List-Help: <mailto:linux1394-devel-request@lists.sourceforge.net?subject=help>
List-Subscribe: <https://lists.sourceforge.net/lists/listinfo/linux1394-devel>,
	<mailto:linux1394-devel-request@lists.sourceforge.net?subject=subscribe>
List-Archive: <http://sourceforge.net/mailarchive/forum.php?forum=linux1394-devel>
To: Christoph Hellwig <hch@infradead.org>
Cc: Jens Axboe <axboe@suse.de>, linux-scsi@vger.kernel.org, patmans@us.ibm.com, adq_dvb@lidskialf.net, linux1394-devel@lists.sourceforge.net, James.Bottomley@steeleye.com
List-Id: linux-scsi@vger.kernel.org

Christoph Hellwig wrote:
> On Sat, Dec 10, 2005 at 09:48:33AM +0100, Jens Axboe wrote:
>>On Fri, Dec 09 2005, Stefan Richter wrote:
>>>scsi: dont allow DMA_TO_DEVICE with zero data length
>>>
>>>When preparing a request in scsi_lib or in a SCSI high-level driver,
>>>always set a transfer direction of DMA_NONE if data length is zero,
>>>even for alleged write requests. (Extended patch derived from Jens
>>>Axboe's version.)
...
>>My quick grep just showed the one, I'd encourage you to turn this into a
>>static inline function instead of duplicating the same code again 3 (or
>>more) times.
> 
> Actually Mike has code pending to remove all copies but the scsi_lib.c
> one.

I was about to prepare a subsequent patch which collapses 4 x 9 lines of
common code of scsi_prep_fn and s[drt]_init_command. I guess Mike's work
goes _much_ further than that, so I'd like to leave it to him. :-)
-- 
Stefan Richter
-=====-=-=-= ==-- -=-=-
http://arcgraph.de/sr/


-------------------------------------------------------
This SF.net email is sponsored by: Splunk Inc. Do you grep through log files
for problems?  Stop!  Download the new AJAX search engine that makes
searching your log files as easy as surfing the  web.  DOWNLOAD SPLUNK!
http://ads.osdn.com/?ad_id=7637&alloc_id=16865&op=click
