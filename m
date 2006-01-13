From: Stefan Richter <stefanr@s5r6.in-berlin.de>
Subject: Re: USB/SCSI slab corruption.
Date: Fri, 13 Jan 2006 01:23:56 +0100
Message-ID: <43C6F31C.5090909@s5r6.in-berlin.de>
References: <20060112233606.GP19827@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-usb-devel-admin@lists.sourceforge.net>
In-Reply-To: <20060112233606.GP19827@redhat.com>
Sender: linux-usb-devel-admin@lists.sourceforge.net
Errors-To: linux-usb-devel-admin@lists.sourceforge.net
List-Unsubscribe: <https://lists.sourceforge.net/lists/listinfo/linux-usb-devel>,
	<mailto:linux-usb-devel-request@lists.sourceforge.net?subject=unsubscribe>
List-Post: <mailto:linux-usb-devel@lists.sourceforge.net>
List-Help: <mailto:linux-usb-devel-request@lists.sourceforge.net?subject=help>
List-Subscribe: <https://lists.sourceforge.net/lists/listinfo/linux-usb-devel>,
	<mailto:linux-usb-devel-request@lists.sourceforge.net?subject=subscribe>
List-Archive: <http://sourceforge.net/mailarchive/forum.php?forum=linux-usb-devel>
To: linux-scsi@vger.kernel.org
Cc: Dave Jones <davej@redhat.com>, linux-usb-devel@lists.sourceforge.net, "F. Poncin" <cr27587@chello.be>
List-Id: linux-scsi@vger.kernel.org

Dave Jones wrote:
> A nasty 2.6.15 report from one of our Fedora users.
> 
> 		Dave
> 
>  > then when it got to map my USB drive: 
>  > SCSI device sdb: 321672960 512-byte hdwr sectors (164697 MB) 
>  > slab error in cache_free_debugcheck(): cache `sgpool-8': double free, or 
>  > memory outside object was overwritten 
>  >  [<c0153593>] cache_free_debugcheck+0x1ab/0x22f     [<c014d3c2>] 
>  > mempool_free+0x3a/0x73 
>  >  [<c01540e2>] kmem_cache_free+0x2a/0x69     [<c014d3c2>] 
>  > mempool_free+0x3a/0x73 
>  >  [<f8862c8b>] scsi_io_completion+0x207/0x4d2 [scsi_mod]     [<f885dcad>] 
>  > scsi_finish_command+0x82/0xd0 [scsi_mod] 
>  >  [<f885db8e>] scsi_softirq+0xc0/0x137 [scsi_mod]     [<c012a152>] 
>  > __do_softirq+0x72/0xdc 
>  >  [<c01063d3>] do_softirq+0x4b/0x4f 
>  >  ======================= 
[...]

This looks very similar to this report about an SBP-2 HDD under 
2.6.14-rc4: http://marc.theaimsgroup.com/?t=112931959700002
-- 
Stefan Richter
-=====-=-==- ---= -==-=
http://arcgraph.de/sr/


-------------------------------------------------------
This SF.net email is sponsored by: Splunk Inc. Do you grep through log files
for problems?  Stop!  Download the new AJAX search engine that makes
searching your log files as easy as surfing the  web.  DOWNLOAD SPLUNK!
http://ads.osdn.com/?ad_id=7637&alloc_id=16865&op=click
_______________________________________________
linux-usb-devel@lists.sourceforge.net
To unsubscribe, use the last form field at:
https://lists.sourceforge.net/lists/listinfo/linux-usb-devel
