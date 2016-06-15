From: "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: Re: [PATCH v3] storvsc: use small sg_tablesize on x86
Date: Tue, 14 Jun 2016 22:07:02 -0400
Message-ID: <yq1fusfb3y1.fsf@sermon.lab.mkp.net>
References: <20160609162553.10290-1-olaf@aepfle.de>
 <1465493159.2259.14.camel@linux.vnet.ibm.com>
 <20160609220120.GA28607@aepfle.de>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <driverdev-devel-bounces@linuxdriverproject.org>
In-Reply-To: <20160609220120.GA28607@aepfle.de> (Olaf Hering's message of
 "Fri, 10 Jun 2016 00:01:20 +0200")
List-Unsubscribe: <http://driverdev.linuxdriverproject.org/mailman/options/driverdev-devel>,
 <mailto:driverdev-devel-request@linuxdriverproject.org?subject=unsubscribe>
List-Archive: <http://driverdev.linuxdriverproject.org/pipermail/driverdev-devel/>
List-Post: <mailto:driverdev-devel@linuxdriverproject.org>
List-Help: <mailto:driverdev-devel-request@linuxdriverproject.org?subject=help>
List-Subscribe: <http://driverdev.linuxdriverproject.org/mailman/listinfo/driverdev-devel>,
 <mailto:driverdev-devel-request@linuxdriverproject.org?subject=subscribe>
Errors-To: driverdev-devel-bounces@linuxdriverproject.org
Sender: "devel" <driverdev-devel-bounces@linuxdriverproject.org>
To: Olaf Hering <olaf@aepfle.de>
Cc: James Bottomley <jejb@linux.vnet.ibm.com>, linux-scsi@vger.kernel.org, "Martin K. Petersen" <martin.petersen@oracle.com>, Haiyang Zhang <haiyangz@microsoft.com>, linux-kernel@vger.kernel.org, devel@linuxdriverproject.org
List-Id: linux-scsi@vger.kernel.org

>>>>> "Olaf" == Olaf Hering <olaf@aepfle.de> writes:

Olaf> On Thu, Jun 09, James Bottomley wrote:
>> On Thu, 2016-06-09 at 18:25 +0200, Olaf Hering wrote:
>> > Reducing the sg_tablesize allows booting of 32bit kernels in VMs, >
>> after > commit be0cf6ca301c61458dc4aa1a37acf4f58d2ed3d6 ("scsi:
>> storvsc: Set > the > tablesize based on the information given by the
>> host")
>> > 
>> > [ 5.567138] hv_storvsc vmbus_1: adjusting sg_tablesize 0x800 -> >
>> 0x20
>> 
>> Are you really sure 32 is the correct size?

Olaf> Its a size that works, while the current state does not work at
Olaf> all.

>> I know 32 it what it had before, but the reason for the commit you
>> quote was to improve performance ...

Olaf> The commit above broke 32bit. Whoever wants to improve performance
Olaf> on this dead horse can submit another patch.

K.Y.?

-- 
Martin K. Petersen	Oracle Linux Engineering
