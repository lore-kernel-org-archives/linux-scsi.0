From: Stefan Richter <stefanr@s5r6.in-berlin.de>
Subject: Re: [PATCH] ieee1394: sbp2: lower block queue alignment requirement
Date: Sun, 14 Jan 2007 21:14:15 +0100 (CET)
Message-ID: <tkrat.cad61efa52eb6e56@s5r6.in-berlin.de>
References: <tkrat.37326df2d568d12d@s5r6.in-berlin.de>
	<1168802387.2780.1.camel@mulgrave.il.steeleye.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux1394-devel-bounces@lists.sourceforge.net>
In-Reply-To: <1168802387.2780.1.camel@mulgrave.il.steeleye.com>
Content-Disposition: INLINE
List-Unsubscribe: <https://lists.sourceforge.net/lists/listinfo/linux1394-devel>,
	<mailto:linux1394-devel-request@lists.sourceforge.net?subject=unsubscribe>
List-Archive: <http://sourceforge.net/mailarchive/forum.php?forum=linux1394-devel>
List-Post: <mailto:linux1394-devel@lists.sourceforge.net>
List-Help: <mailto:linux1394-devel-request@lists.sourceforge.net?subject=help>
List-Subscribe: <https://lists.sourceforge.net/lists/listinfo/linux1394-devel>,
	<mailto:linux1394-devel-request@lists.sourceforge.net?subject=subscribe>
Sender: linux1394-devel-bounces@lists.sourceforge.net
Errors-To: linux1394-devel-bounces@lists.sourceforge.net
To: James Bottomley <James.Bottomley@SteelEye.com>
Cc: linux1394-devel@lists.sourceforge.net, linux-scsi@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

On 14 Jan, James Bottomley wrote:
> The block layer currently provides sector (512) byte alignment
> guarantees.  However, there has been talk in SCSI of reducing that to
> word (4) since that's what most intelligent PCI controllers can cope
> with.  If you have any alignment constraints, they should be expressed
> in the slave configure.

OK, thanks. I will keep the explicit setting of the mask then.
I actually think that everything should work just fine with 4 bytes
alignment, but the SBP-2 spec mentiones 8 bytes alignment for the S/G
tables.  So maybe device firmwares will expect it that way even though
IEEE 1394 doesn't impose such a restriction even on transfers with a
payload of a multiple of 8 bytes.
-- 
Stefan Richter
-=====-=-=== ---= -===-
http://arcgraph.de/sr/


-------------------------------------------------------------------------
Take Surveys. Earn Cash. Influence the Future of IT
Join SourceForge.net's Techsay panel and you'll get the chance to share your
opinions on IT & business topics through brief surveys - and earn cash
http://www.techsay.com/default.php?page=join.php&p=sourceforge&CID=DEVDEV
