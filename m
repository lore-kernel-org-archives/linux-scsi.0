From: "Moger, Babu" <Babu.Moger@lsi.com>
Subject: qla2xxx 0000:03:0c.0: Firmware image unavailable
Date: Wed, 21 Jan 2009 17:00:09 -0700
Message-ID: <E463DF2B2E584B4A82673F53D62C2EF45CEAB48E@cosmail01.lsi.com>
References: <1225944321.14830.1109.camel@chandra-ubuntu>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
Return-path: <dm-devel-bounces@redhat.com>
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
To: "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, device-mapper development <dm-devel@redhat.com>
List-Id: linux-scsi@vger.kernel.org

Hi All,
Have you guys seen this following error?=20

Jan 21 16:30:44 txmpp2 kernel: qla2xxx 0000:03:0c.0: Firmware image unava=
ilable.=20
Jan 21 16:30:44 txmpp2 kernel: qla2xxx 0000:03:0c.0: Firmware images can =
be retrieved from: ftp://ftp.qlogic.com/outgoing/linux/firmware/.

After this error, qlogic driver fails to detect the LUNs attached.=20

I am running 2.6.29-rc2 kernel on x86_64 machine.

I tried couple of things without any success. I downloaded all the qlogic=
 firmwares available and kept it in /lib/firmware. Tried rebuilding the k=
ernel. Did not help. Thanks in advance.=20


Thanks
Babu Moger=20
