From: Douglas Gilbert <dougg@torque.net>
Subject: Re: Fw: [Bugme-new] [Bug 6114] New: Initio sbp2 causes: "slab error
 in cache_free_debugcheck(): cache `size-512(DMA)': double free, or memory
 outside" object was overwritten
Date: Tue, 21 Feb 2006 21:39:44 -0500
Message-ID: <43FBCEF0.4090208@torque.net>
References: <43FBB608.5060202@torque.net> <20060222012057.GX27946@ftp.linux.org.uk>
Reply-To: dougg@torque.net
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux1394-devel-admin@lists.sourceforge.net>
In-Reply-To: <20060222012057.GX27946@ftp.linux.org.uk>
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
Cc: linux-scsi@vger.kernel.org, linux1394-devel@lists.sourceforge.net
List-Id: linux-scsi@vger.kernel.org

>>Stefan Richter wrote:
>>>What I don't understand is why mode page 8 is still accessed in your
>>>log: http://bugzilla.kernel.org/attachment.cgi?id=7432&action=view
>>>(Log lines "command: Mode Sense (10): 5a 00 08 00 00 00 00 00 d9 00",

Also apart from being a MODE SENSE (10) rather than the
required MODE SENSE (6), the DBD bit is not set as
required by: www.t10.org/ftp/t10/drafts/rbc/rbc-r10a.pdf
section 6.3 .

Perhaps someone could try setting DBD and see if
the bridge is any better behaved. The cdb would be:
  5a 08 08 00 ....   or
  1a 08 08 00 ....

Doug Gilbert


-------------------------------------------------------
This SF.net email is sponsored by: Splunk Inc. Do you grep through log files
for problems?  Stop!  Download the new AJAX search engine that makes
searching your log files as easy as surfing the  web.  DOWNLOAD SPLUNK!
http://sel.as-us.falkag.net/sel?cmd=lnk&kid=103432&bid=230486&dat=121642
