From: Johannes Thumshirn <jthumshirn-l3A5Bk7waGM@public.gmane.org>
Subject: [ANOUNCE] New open-fcoe release v1.0.32
Date: Tue, 17 Jan 2017 13:29:08 +0100
Message-ID: <20170117122908.GC6067@linux-x5ow.site>
Mime-Version: 1.0
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Return-path: <fcoe-devel-bounces-s9riP+hp16TNLxjTenLetw@public.gmane.org>
Content-Disposition: inline
List-Unsubscribe: <http://lists.open-fcoe.org/mailman/options/fcoe-devel>,
 <mailto:fcoe-devel-request-s9riP+hp16TNLxjTenLetw@public.gmane.org?subject=unsubscribe>
List-Archive: <http://lists.open-fcoe.org/pipermail/fcoe-devel/>
List-Post: <mailto:fcoe-devel-s9riP+hp16TNLxjTenLetw@public.gmane.org>
List-Help: <mailto:fcoe-devel-request-s9riP+hp16TNLxjTenLetw@public.gmane.org?subject=help>
List-Subscribe: <http://lists.open-fcoe.org/mailman/listinfo/fcoe-devel>,
 <mailto:fcoe-devel-request-s9riP+hp16TNLxjTenLetw@public.gmane.org?subject=subscribe>
Errors-To: fcoe-devel-bounces-s9riP+hp16TNLxjTenLetw@public.gmane.org
Sender: "fcoe-devel" <fcoe-devel-bounces-s9riP+hp16TNLxjTenLetw@public.gmane.org>
To: fcoe-devel-s9riP+hp16TNLxjTenLetw@public.gmane.org
Cc: Linux SCSI Mailinglist <linux-scsi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-scsi@vger.kernel.org

Hi,

I've tagged a new release v1.0.32 of fcoe-utils at
https://github.com/morbidrsa/fcoe-utils/

There's not much news here's the git log:
Chad Dupuis (1):
      fcoemon: Add retry mechanism during fip vlan discovery if socket fail=
s to open.

Chris Leech (2):
      fcoeadm: --target segfault with other FC storage present
      sanmac isn't required

Hannes Reinecke (3):
      fcoemon: fixup log_nlmsg_error()
      fcoemon: Add debugging message for 'recv'
      Fallback to default MAC address for FIP

Johannes Thumshirn (2):
      fcoeadm: Fix possible buffer overflows
      fcoe-utils: increment fcoe-utils version to 1.0.32

Milan P. Gandhi (3):
      fcoemon.c: Add a check to verify if dcbd is to be initialized, else d=
o not try to connect to dcbd/lldpad
      fix a minor typo in fcoeadm_display.c, fcoemon.h and fcping.c
      Print an error upon failure in memory allocation for struct pollfd

-- =

Johannes Thumshirn                                          Storage
jthumshirn-l3A5Bk7waGM@public.gmane.org                                +49 911 74053 689
SUSE LINUX GmbH, Maxfeldstr. 5, 90409 N=FCrnberg
GF: Felix Imend=F6rffer, Jane Smithard, Graham Norton
HRB 21284 (AG N=FCrnberg)
Key fingerprint =3D EC38 9CAB C2C4 F25D 8600 D0D0 0393 969D 2D76 0850
