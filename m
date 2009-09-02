From: "Moger, Babu" <Babu.Moger@lsi.com>
Subject: [PATCH 0/3][RESUBMIT] scsi_dh_rdac: Adding more debug
 options for scsi rdac handler
Date: Wed, 2 Sep 2009 17:12:21 -0600
Message-ID: <E463DF2B2E584B4A82673F53D62C2EF474CCCE66@cosmail01.lsi.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="iso-8859-1"
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
To: "'linux-scsi@vger.kernel.org'" <linux-scsi@vger.kernel.org>
Cc: "Dachepalli, Sudhir" <Sudhir.Dachepalli@lsi.com>, "dm-devel@redhat.com" <dm-devel@redhat.com>, "Chauhan,
	Vijay" <Vijay.Chauhan@lsi.com>, "Stankey, Robert" <Robert.Stankey@lsi.com>, "'sekharan@linux.vnet.ibm.com'" <sekharan@linux.vnet.ibm.com>
List-Id: linux-scsi@vger.kernel.org

Hi All,
These patches add more debugging options to scsi rdac device handler. Thi=
s can considerably reduce the time taken to=20
debug issues in big configurations and also very helpful in addressing th=
e support issues.
Here is the summary of changes.=20
- Added a bit mask "module parameter" rdac_logging with 2 bits for each t=
ype of logging.
- currently defined only two types of logging(failover and sense logging)=
. Can be enhanced later if required.
- By default only failover logging is enabled which is equivalent of curr=
ent logging.

Thanks to Chandra, Vijay and Bob for their useful comments. This code has=
 been tested on 2.6.31-rc5.

Signed-off-by: Babu Moger <babu.moger@lsi.com>
Reviewed-by: Vijay Chauhan <vijay.chauhan@lsi.com>
Reviewed-by: Bob Stankey <Robert.stankey@lsi.com>
