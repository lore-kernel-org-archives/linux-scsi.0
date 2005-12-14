From: Mike Christie <michaelc@cs.wisc.edu>
Subject: Re: stgt a new version of iscsi target?
Date: Wed, 14 Dec 2005 13:55:53 -0600
Message-ID: <43A078C9.1040007@cs.wisc.edu>
References: <OF6932015B.01CF53D9-ONC12570D0.00462028@capvert.ins>	 <43972C2D.9060500@cs.wisc.edu>  <43987F75.2000301@vlnb.net>	 <1134071268.3259.29.camel@mulgrave>  <4399A2D7.2040402@vlnb.net> <1134143298.3598.21.camel@mulgrave> <439AF52B.7060203@vlnb.net> <439B1965.90603@cs.wisc.edu> <43A03500.1040500@vlnb.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <iscsitarget-devel-admin@lists.sourceforge.net>
In-Reply-To: <43A03500.1040500@vlnb.net>
Sender: iscsitarget-devel-admin@lists.sourceforge.net
Errors-To: iscsitarget-devel-admin@lists.sourceforge.net
List-Unsubscribe: <https://lists.sourceforge.net/lists/listinfo/iscsitarget-devel>,
	<mailto:iscsitarget-devel-request@lists.sourceforge.net?subject=unsubscribe>
List-Post: <mailto:iscsitarget-devel@lists.sourceforge.net>
List-Help: <mailto:iscsitarget-devel-request@lists.sourceforge.net?subject=help>
List-Subscribe: <https://lists.sourceforge.net/lists/listinfo/iscsitarget-devel>,
	<mailto:iscsitarget-devel-request@lists.sourceforge.net?subject=subscribe>
List-Archive: <http://sourceforge.net/mailarchive/forum.php?forum=iscsitarget-devel>
To: Vladislav Bolkhovitin <vst@vlnb.net>
Cc: James Bottomley <James.Bottomley@SteelEye.com>, johan@capvert.se, iscsitarget-devel@lists.sourceforge.net, mingz@ele.uri.edu, stgt <stgt-devel@lists.berlios.de>, Robert Whitehead <WRWHITEHEAD@novell.com>, scst-devel@lists.sourceforge.net, linux-scsi@vger.kernel.org, Christoph Hellwig <hch@infradead.org>
List-Id: linux-scsi@vger.kernel.org

Vladislav Bolkhovitin wrote:
> Mike Christie wrote:
> 
>>>
>>> Are you sure that there are no now or will be available in the 
>>> nearest feature such (eg iSCSI) SCSI arrays with response 
>>> time/latency so small that having 5 (five) context switches or more 
>>> per command, some of which include map/unmap operations, will not 
>>> increase the latency too much? I mean, eg NFS server, which 
>>> originally was user space daemon and many people didn't want it in 
>>> the kernel. Eventually, it's in. I don't see any fundamental 
>>> difference between NFS server and SCSI target server, 
>>
>>
>>
>> Isn't the reason a NFS server is still in the kernel is becuase some 
>> of the locking difficulties?
> 
> 
> Might be. But from what I remember, the major reason was the 
> performance. After googling a bit I found many acknowledgments of that.
> 

I do not think we are going to get anywhere with this type of thread :(

We should try to compare at least one of the userspace *nbd 
implementations with the unh target in scst. I see some that just do 
some basic socket ops (no sendfile type hook in even) for the network 
part then just async or normal read/writes. I do not want to comapre FC 
to nbd, but maybe comparing software iscsi to userspace nbd is a little 
more fair. I think ata over ethernet has a userspace target too. Is the 
unh target defaults set ok for performance testing, or could you send 
some off list, so we can at least test those.


-------------------------------------------------------
This SF.net email is sponsored by: Splunk Inc. Do you grep through log files
for problems?  Stop!  Download the new AJAX search engine that makes
searching your log files as easy as surfing the  web.  DOWNLOAD SPLUNK!
http://ads.osdn.com/?ad_id=7637&alloc_id=16865&op=click
