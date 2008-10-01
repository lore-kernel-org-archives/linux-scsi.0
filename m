From: "Moger, Babu" <Babu.Moger@lsi.com>
Subject: failover does not work with rdac device handler
Date: Wed, 1 Oct 2008 15:47:58 -0600
Message-ID: <E463DF2B2E584B4A82673F53D62C2EF45BB4E86E@cosmail01.lsi.com>
References: <00FE57DD11E3A94893D5BD54C3358BE884BF36@AUSX3MPC128.aus.amer.dell.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <00FE57DD11E3A94893D5BD54C3358BE884BF36@AUSX3MPC128.aus.amer.dell.com>
Content-Language: en-US
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: device-mapper development <dm-devel@redhat.com>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org

Hi All,

I am new to the device mapper and just thought I will set-up device mappe=
r on our arrays. I am using the latest kernel 2.6.27.rc6 and got the late=
st multipath-tools from upstream.

I updated /etc/multipath.conf with all the information (vendor, product, =
hardware_handler, prio etc  ...). Note that my device is not part of rdac=
_dev_list.

Discovery worked fine. "multipath -ll" displays all the information. I ca=
n see that it is picking up rdac device handler.

But I found that for some reason failover/failback is not working.  I am =
seeing following these messages.

"device-mapper: multipath: Cannot failover device because scsi_dh_rdac wa=
s not loaded."

I can see that scsi_dh_rdac driver is already loaded.

I did some more investigation. Found that failover works fine if I add ve=
ndor, model in rdac_dev_list (in file scsi_dh_rdac.c).

My question - is it required to add all the supported vendor and model na=
mes in rdac_dev_list?

Appreciate your responses.

Thanks
Babu Moger
