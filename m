From: Stefan Richter <stefanr@s5r6.in-berlin.de>
Subject: Re: infinite loop with 36 Byte inquiry (sbp2 regression in 2.6.14-rcX)
Date: Sun, 23 Oct 2005 09:46:14 +0200
Message-ID: <435B3FC6.2070307@s5r6.in-berlin.de>
References: <435ADA6D.4040705@s5r6.in-berlin.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux1394-devel-admin@lists.sourceforge.net>
In-Reply-To: <435ADA6D.4040705@s5r6.in-berlin.de>
Sender: linux1394-devel-admin@lists.sourceforge.net
Errors-To: linux1394-devel-admin@lists.sourceforge.net
List-Unsubscribe: <https://lists.sourceforge.net/lists/listinfo/linux1394-devel>,
	<mailto:linux1394-devel-request@lists.sourceforge.net?subject=unsubscribe>
List-Post: <mailto:linux1394-devel@lists.sourceforge.net>
List-Help: <mailto:linux1394-devel-request@lists.sourceforge.net?subject=help>
List-Subscribe: <https://lists.sourceforge.net/lists/listinfo/linux1394-devel>,
	<mailto:linux1394-devel-request@lists.sourceforge.net?subject=subscribe>
List-Archive: <http://sourceforge.net/mailarchive/forum.php?forum=linux1394-devel>
To: linux1394-devel@lists.sourceforge.net, linux-scsi@vger.kernel.org
Cc: Ben Collins <bcollins@debian.net>
List-Id: linux-scsi@vger.kernel.org

PS: The subject is a badly worded. The loop occurs with any type of 
inquiry, with a SBP-2 bridge's firmware which expects 36 Byte inquiry.
-- 
Stefan Richter
-=====-=-=-= =-=- =-===
http://arcgraph.de/sr/


-------------------------------------------------------
This SF.Net email is sponsored by the JBoss Inc.
Get Certified Today * Register for a JBoss Training Course
Free Certification Exam for All Training Attendees Through End of 2005
Visit http://www.jboss.com/services/certification for more information
