From: "Barnes, Clifton A." <cabarnes@indesign-llc.com>
Subject: Re: [PATCH 7/8] w1: ds2760 and ds2780,
 use ida for id and ida_simple_get to get it.
Date: Wed, 24 Aug 2011 17:22:46 +0000
Message-ID: <A8DC7EA93EFCBD4498E3857AFE65E5F1A5A2B9C8@IND07.indesign.net>
References: <1311352886-4047-1-git-send-email-jic23@cam.ac.uk>
	<1311352886-4047-17-git-send-email-jic23@cam.ac.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <lm-sensors-bounces@lm-sensors.org>
In-Reply-To: <1311352886-4047-17-git-send-email-jic23@cam.ac.uk>
Content-Language: en-US
List-Unsubscribe: <http://lists.lm-sensors.org/mailman/options/lm-sensors>,
	<mailto:lm-sensors-request@lm-sensors.org?subject=unsubscribe>
List-Archive: <http://lists.lm-sensors.org/pipermail/lm-sensors/>
List-Post: <mailto:lm-sensors@lm-sensors.org>
List-Help: <mailto:lm-sensors-request@lm-sensors.org?subject=help>
List-Subscribe: <http://lists.lm-sensors.org/mailman/listinfo/lm-sensors>,
	<mailto:lm-sensors-request@lm-sensors.org?subject=subscribe>
Sender: lm-sensors-bounces@lm-sensors.org
Errors-To: lm-sensors-bounces@lm-sensors.org
To: Jonathan Cameron <jic23@cam.ac.uk>
Cc: "randy.dunlap@oracle.com" <randy.dunlap@oracle.com>, "airlied@linux.ie" <airlied@linux.ie>, "dri-devel@lists.freedesktop.org" <dri-devel@lists.freedesktop.org>, "johnpol@2ka.mipt.ru" <johnpol@2ka.mipt.ru>, "thellstrom@vmware.com" <thellstrom@vmware.com>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, "lm-sensors@lm-sensors.org" <lm-sensors@lm-sensors.org>, "bharrosh@panasas.com" <bharrosh@panasas.com>, "airlied@redhat.com" <airlied@redhat.com>, "paulmck@linux.vnet.ibm.com" <paulmck@linux.vnet.ibm.com>, "naota@elisp.net" <naota@elisp.net>, "rtc-linux@googlegroups.com" <rtc-linux@googlegroups.com>, "namhyung@gmail.com" <namhyung@gmail.com>, "rusty@rustcorp.com.au" <rusty@rustcorp.com.au>, "tj@kernel.org" <tj@kernel.org>, "osd-dev@open-osd.org" <osd-dev@open-osd.org>, "bhalevy@panasas.com" <bhalevy@panasas.com>, "a.zummo@towertech.it" <a.zummo@towertech.it>
List-Id: linux-scsi@vger.kernel.org

On Fri 7/22/2011 12:41 PM, Jonathan Cameron wrote:

> Straight forward.  As an aside, the ida_init calls are not needed as far
> as I can see needed. (DEFINE_IDA does the same already).

> Signed-off-by: Jonathan Cameron <jic23@cam.ac.uk>

Checked out ok here for ds2780.

Acked-by: Clifton Barnes <cabarnes@indesign-llc.com>

_______________________________________________
lm-sensors mailing list
lm-sensors@lm-sensors.org
http://lists.lm-sensors.org/mailman/listinfo/lm-sensors
