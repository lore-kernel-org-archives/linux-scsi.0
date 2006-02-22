From: Stefan Richter <stefanr@s5r6.in-berlin.de>
Subject: Re: Fw: [Bugme-new] [Bug 6114] New: Initio sbp2 causes: "slab error
 in cache_free_debugcheck(): cache `size-512(DMA)': double free, or memory
 outside" object was overwritten
Date: Wed, 22 Feb 2006 07:05:40 +0100
Message-ID: <43FBFF34.9080909@s5r6.in-berlin.de>
References: <20060221040511.35b69d26.akpm@osdl.org> <43FB6545.8080103@s5r6.in-berlin.de> <43FB67BD.7030101@s5r6.in-berlin.de> <20060221134543.5f844d7c.akpm@osdl.org> <43FB9FE5.8070309@s5r6.in-berlin.de> <Pine.LNX.4.64.0602220041070.21474@jbgna.fhfr.qr> <43FBB1A2.9030009@s5r6.in-berlin.de> <20060222012942.GY27946@ftp.linux.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux1394-devel-admin@lists.sourceforge.net>
In-Reply-To: <20060222012942.GY27946@ftp.linux.org.uk>
Sender: linux1394-devel-admin@lists.sourceforge.net
Errors-To: linux1394-devel-admin@lists.sourceforge.net
List-Unsubscribe: <https://lists.sourceforge.net/lists/listinfo/linux1394-devel>,
	<mailto:linux1394-devel-request@lists.sourceforge.net?subject=unsubscribe>
List-Post: <mailto:linux1394-devel@lists.sourceforge.net>
List-Help: <mailto:linux1394-devel-request@lists.sourceforge.net?subject=help>
List-Subscribe: <https://lists.sourceforge.net/lists/listinfo/linux1394-devel>,
	<mailto:linux1394-devel-request@lists.sourceforge.net?subject=subscribe>
List-Archive: <http://sourceforge.net/mailarchive/forum.php?forum=linux1394-devel>
To: Al Viro <viro@ftp.linux.org.uk>
Cc: Bernhard Kaindl <bk@suse.de>, Andrew Morton <akpm@osdl.org>, bcollins@debian.org, scjody@modernduck.com, linux1394-devel@lists.sourceforge.net, linux-scsi@vger.kernel.org, James Bottomley <James.Bottomley@SteelEye.com>
List-Id: linux-scsi@vger.kernel.org

Al Viro wrote:
> On Wed, Feb 22, 2006 at 01:34:42AM +0100, Stefan Richter wrote:
> 
>>Al's patch is certainly better since it adds checks to the actual 
>>affected code region, i.e. mode_sense handling in the SCSI layers. 
>>James, would you integrate this patch?
>>
>>However sbp2 will keep some sort of skip_ms_page_8 blacklisting anyway 
>>because of different issues with other bridges.
> 
> 
> Sure, but for this bridge it's not needed - with that fix we get the
> right data out of bridge response.  Note
> +sda: missing header in MODE_SENSE response
> and
> +SCSI device sda: drive cache: write back
> in that diff.  The former is exactly what we get when we detect that
> sort of breakage (bare page 6 without header) and the latter is where
> we manage to get the cache type.

Yes, you are definitly right about it.
-- 
Stefan Richter
-=====-=-==- --=- =-==-
http://arcgraph.de/sr/


-------------------------------------------------------
This SF.net email is sponsored by: Splunk Inc. Do you grep through log files
for problems?  Stop!  Download the new AJAX search engine that makes
searching your log files as easy as surfing the  web.  DOWNLOAD SPLUNK!
http://sel.as-us.falkag.net/sel?cmd=lnk&kid=103432&bid=230486&dat=121642
