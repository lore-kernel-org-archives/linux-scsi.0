From: Hidetoshi Seto <seto.hidetoshi@jp.fujitsu.com>
Subject: Re: [PATCH 1/5] Update Documentation/pci.txt
Date: Fri, 24 Nov 2006 15:05:18 +0900
Message-ID: <45668B9E.60008@jp.fujitsu.com>
References: <456404E2.1060102@jp.fujitsu.com>
	<20061122182804.GE378@colo.lackof.org>
	<45663EE8.1080708@jp.fujitsu.com>
	<20061124051217.GB8202@colo.lackof.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <e1000-devel-bounces@lists.sourceforge.net>
In-Reply-To: <20061124051217.GB8202@colo.lackof.org>
List-Unsubscribe: <https://lists.sourceforge.net/lists/listinfo/e1000-devel>,
	<mailto:e1000-devel-request@lists.sourceforge.net?subject=unsubscribe>
List-Archive: <http://sourceforge.net/mailarchive/forum.php?forum=e1000-devel>
List-Post: <mailto:e1000-devel@lists.sourceforge.net>
List-Help: <mailto:e1000-devel-request@lists.sourceforge.net?subject=help>
List-Subscribe: <https://lists.sourceforge.net/lists/listinfo/e1000-devel>,
	<mailto:e1000-devel-request@lists.sourceforge.net?subject=subscribe>
Sender: e1000-devel-bounces@lists.sourceforge.net
Errors-To: e1000-devel-bounces@lists.sourceforge.net
To: Grant Grundler <grundler@parisc-linux.org>
Cc: Andrew Morton <akpm@osdl.org>, linux-scsi@vger.kernel.org, e1000-devel@lists.sourceforge.net, Greg KH <greg@kroah.com>, Linux Kernel list <linux-kernel@vger.kernel.org>, Kenji Kaneshige <kaneshige.kenji@jp.fujitsu.com>, linux-pci@atrey.karlin.mff.cuni.cz
List-Id: linux-scsi@vger.kernel.org

Grant Grundler wrote:
> On Fri, Nov 24, 2006 at 09:38:00AM +0900, Hidetoshi Seto wrote:
>> Grant Grundler wrote:
>>> Hidetoshi,
>>> I have a nearly finished rewrite of Documentation/pci.txt.
>>> Can you drop this patch for now on my promise to integrate
>>> your proposed text?
>> No problem at all.
> 
> Thanks - I've posted pci.txt-05 on:
> 	http://www.parisc-linux.org/~grundler/pci.txt-05
> 
> and appended it below.
> 
> pci.txt-03 is the last version I posted.
> pci.txt-04 contains all feedback from Andi Kleen and Randi Dunlap
>            (plus a few other minor changes)
> pci.txt-05 reverts pci_enable_device/pci_request_resource ordering to
> 	reflect current reality. But I've added a comment to remind us
> 	about the issue. Also added Section 10/11 from Hidetoshi-san.
> 	A few minor other changes as well.
> 
> If this looks good, I'll post a diff for gregkh.
> 
> thanks,
> grant

Thank you very much!

I confirmed few minor fixes in section 10/11.
I ACK them.

Yes, this looks good. Please take your turn, Greg.

Thanks,
H.Seto


-------------------------------------------------------------------------
Take Surveys. Earn Cash. Influence the Future of IT
Join SourceForge.net's Techsay panel and you'll get the chance to share your
opinions on IT & business topics through brief surveys - and earn cash
http://www.techsay.com/default.php?page=join.php&p=sourceforge&CID=DEVDEV
