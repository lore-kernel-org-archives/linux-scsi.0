From: James Bottomley <James.Bottomley@HansenPartnership.com>
Subject: Re: [PATCH][RESUBMIT] scsi_dh_rdac: Retry mode select for
	NO_SENSE, ABORTED_COMMAND, UNIT_ATTENTION, NOT_READY(02/04/01)
Date: Wed, 11 Mar 2009 20:48:50 +0000
Message-ID: <1236804530.3270.92.camel@localhost.localdomain>
References: <0D1E8821739E724A86F4D16902CE275C140E25C59C@inbmail01.lsi.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <0D1E8821739E724A86F4D16902CE275C140E25C59C@inbmail01.lsi.com>
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: "Chauhan, Vijay" <Vijay.Chauhan@lsi.com>
Cc: "dm-devel@redhat.com" <dm-devel@redhat.com>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org

On Wed, 2009-03-04 at 12:17 +0530, Chauhan, Vijay wrote:
> Hi Hannes,
> 
> Thanks for your comment. I have modified the patch with correct indentation. Resubmitting this patch.
> For other ASC/ASQ codes (ie 04/04 - 04/09), I am  currently working on it and will be adding it
> in future if needed.

checkpatch.pl doesn't like you very much:

jejb@mulgrave> ./scripts/checkpatch.pl ~/tmp.mail
ERROR: spaces required around that '=' (ctx:VxW)
#135: FILE: drivers/scsi/device_handler/scsi_dh_rdac.c:464:
+               err= SCSI_DH_RETRY;
                   ^

WARNING: line over 80 characters
#154: FILE: drivers/scsi/device_handler/scsi_dh_rdac.c:482:
+                       "MODE_SELECT failed with sense %02x/%02x/%02x.\n",sense_hdr.sense_key,

ERROR: space required after that ',' (ctx:VxV)
#154: FILE: drivers/scsi/device_handler/scsi_dh_rdac.c:482:
+                       "MODE_SELECT failed with sense %02x/%02x/%02x.\n",sense_hdr.sense_key,
                                                                         ^

ERROR: space prohibited before that close parenthesis ')'
#155: FILE: drivers/scsi/device_handler/scsi_dh_rdac.c:483:
+                        sense_hdr.asc, sense_hdr.ascq );

total: 3 errors, 1 warnings, 54 lines checked

I fixed all of this, but could you try running checkpatch.pl before
submitting, next time.

James
