From: "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: Re: [PATCH] scsi: acornscsi: fix build error
Date: Thu, 14 Sep 2017 21:03:31 -0400
Message-ID: <yq11sn8srh8.fsf@oracle.com>
References: <20170911200115.3119398-1-arnd@arndb.de>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-arm-kernel-bounces+linux-arm-kernel=m.gmane.org@lists.infradead.org>
In-Reply-To: <20170911200115.3119398-1-arnd@arndb.de> (Arnd Bergmann's message
 of "Mon, 11 Sep 2017 22:00:57 +0200")
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
Cc: "James E.J. Bottomley" <jejb@linux.vnet.ibm.com>, linux-scsi@vger.kernel.org, "Martin K. Petersen" <martin.petersen@oracle.com>, Russell King <linux@armlinux.org.uk>, linux-kernel@vger.kernel.org, Hannes Reinecke <hare@suse.de>, Johannes Thumshirn <jthumshirn@suse.de>, linux-arm-kernel@lists.infradead.org
List-Id: linux-scsi@vger.kernel.org


Arnd,

> A cleanup patch introduced a fatal typo from inbalanced curly braces:

Applied to 4.14/scsi-fixes. Thanks!

-- 
Martin K. Petersen	Oracle Linux Engineering
