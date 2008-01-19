From: Stefan Richter <stefanr@s5r6.in-berlin.de>
Subject: Re: [Bug 9734] New: I/O error when inserting a second firewire sata
	disk
Date: Sat, 19 Jan 2008 21:47:41 +0100
Message-ID: <479261ED.1010703@s5r6.in-berlin.de>
References: <bug-9734-11613@http.bugzilla.kernel.org/>
	<1200186705.3656.83.camel@localhost.localdomain>
	<tkrat.da7b74482b7735a6@s5r6.in-berlin.de>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux1394-devel-bounces@lists.sourceforge.net>
In-Reply-To: <tkrat.da7b74482b7735a6@s5r6.in-berlin.de>
List-Unsubscribe: <https://lists.sourceforge.net/lists/listinfo/linux1394-devel>,
	<mailto:linux1394-devel-request@lists.sourceforge.net?subject=unsubscribe>
List-Archive: <http://sourceforge.net/mailarchive/forum.php?forum_name=linux1394-devel>
List-Post: <mailto:linux1394-devel@lists.sourceforge.net>
List-Help: <mailto:linux1394-devel-request@lists.sourceforge.net?subject=help>
List-Subscribe: <https://lists.sourceforge.net/lists/listinfo/linux1394-devel>,
	<mailto:linux1394-devel-request@lists.sourceforge.net?subject=subscribe>
Sender: linux1394-devel-bounces@lists.sourceforge.net
Errors-To: linux1394-devel-bounces@lists.sourceforge.net
To: linux1394-devel@lists.sourceforge.net
Cc: James Bottomley <James.Bottomley@HansenPartnership.com>, Kristian Hoegsberg <krh@bitplanet.net>, linux-scsi@vger.kernel.org, bugme-daemon@bugzilla.kernel.org
List-Id: linux-scsi@vger.kernel.org

Stefan Richter wrote:
> However, the first thing I shall try is to insert a "return
> SCSI_MLQUEUE_HOST_BUSY" early in sbp2_scsi_queuecommand, depending on a
> check of the logical unit's generation.

Doesn't help.  Even worse, it's deadlocky.
-- 
Stefan Richter
-=====-==--- ---= =--==
http://arcgraph.de/sr/

-------------------------------------------------------------------------
This SF.net email is sponsored by: Microsoft
Defy all challenges. Microsoft(R) Visual Studio 2008.
http://clk.atdmt.com/MRT/go/vse0120000070mrt/direct/01/
