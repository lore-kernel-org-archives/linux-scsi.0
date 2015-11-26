From: "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: Re: [PATCH] scsi: use sector_div instead of do_div
Date: Wed, 25 Nov 2015 22:28:34 -0500
Message-ID: <yq1bnahjv6l.fsf@sermon.lab.mkp.net>
References: <24882658.08y4bWL6tn@wuerfel>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-arm-kernel-bounces+linux-arm-kernel=m.gmane.org@lists.infradead.org>
In-Reply-To: <24882658.08y4bWL6tn@wuerfel> (Arnd Bergmann's message of "Fri,
 20 Nov 2015 17:38:28 +0100")
List-Unsubscribe: <http://lists.infradead.org/mailman/options/linux-arm-kernel>,
 <mailto:linux-arm-kernel-request@lists.infradead.org?subject=unsubscribe>
List-Archive: <http://lists.infradead.org/pipermail/linux-arm-kernel/>
List-Post: <mailto:linux-arm-kernel@lists.infradead.org>
List-Help: <mailto:linux-arm-kernel-request@lists.infradead.org?subject=help>
List-Subscribe: <http://lists.infradead.org/mailman/listinfo/linux-arm-kernel>,
 <mailto:linux-arm-kernel-request@lists.infradead.org?subject=subscribe>
Sender: "linux-arm-kernel" <linux-arm-kernel-bounces@lists.infradead.org>
Errors-To: linux-arm-kernel-bounces+linux-arm-kernel=m.gmane.org@lists.infradead.org
To: Arnd Bergmann <arnd@arndb.de>
Cc: linux-scsi@vger.kernel.org, martin.petersen@oracle.com, nico@fluxnic.net, jbottomley@odin.com, linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org
List-Id: linux-scsi@vger.kernel.org

>>>>> "Arnd" == Arnd Bergmann <arnd@arndb.de> writes:

Arnd> do_div is the wrong way to divide a sector_t, as it is less
Arnd> efficient when sector_t is 32-bit wide. With the upcoming do_div
Arnd> optimizations, the kernel starts warning about this:

Applied.

-- 
Martin K. Petersen	Oracle Linux Engineering
