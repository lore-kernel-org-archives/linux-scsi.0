From: "Moger, Babu" <Babu.Moger@lsi.com>
Subject: RE: SCSI Hardware Handler and slow failover with large
 number of LUNS
Date: Mon, 6 Apr 2009 07:44:03 -0700
Message-ID: <E463DF2B2E584B4A82673F53D62C2EF466954724@cosmail01.lsi.com>
References: <1238880636.11478.8.camel@chandra-ubuntu>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <1238880636.11478.8.camel@chandra-ubuntu>
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
To: "sekharan@linux.vnet.ibm.com" <sekharan@linux.vnet.ibm.com>, dm-devel <dm-devel@redhat.com>, Linux SCSI Mailing list <linux-scsi@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org


Thanks Chandra for bringing this up.

Yes this will be a major drawback for the users who use rdac handler for =
their storage with large configurations.

Thanks
Babu Moger=20

-----Original Message-----
From: Chandra Seetharaman [mailto:sekharan@us.ibm.com]=20
Sent: Saturday, April 04, 2009 4:31 PM
To: dm-devel; Linux SCSI Mailing list
Cc: Moger, Babu
Subject: SCSI Hardware Handler and slow failover with large number of LUN=
S

Hello All,

During testing with the latest SCSI DH Handler on a rdac storage, Babu
found that the failover time with 100+ luns takes about 15 minutes,
which is not good.

We found that the problem is due to the fact that we serialize activate
in dm on the work queue.

We can solve the problem in rdac handler in 2 ways
 1. batch up the activates (mode_selects) and send few of them.
 2. Do mode selects in async mode.

Just wondering if anybody had seen the same problem in other storages
(EMC, HP and Alua).=20

Please share your experiences, so we can come up with a solution that
works for all hardware handlers.

regards,

chandra
