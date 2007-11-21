From: James Smart <James.Smart@Emulex.Com>
Subject: Re: [PATCH v3 2/2][BNX2]: Add iSCSI support to BNX2 devices.
Date: Wed, 21 Nov 2007 14:17:22 -0500
Message-ID: <47448442.7040308@emulex.com>
References: <1188599815.5176.12.camel@dell> <46DEF69D.3090901@redhat.com> <1189027622.19638.42.camel@dhcp-10-13-106-205.broadcom.com> <46E1CF4B.9080407@cs.wisc.edu> <1195670296.8767.9.camel@dhcp-10-13-106-205.broadcom.com>
Reply-To: James.Smart@Emulex.Com
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <netdev-owner@vger.kernel.org>
In-Reply-To: <1195670296.8767.9.camel@dhcp-10-13-106-205.broadcom.com>
Sender: netdev-owner@vger.kernel.org
To: Anil Veerabhadrappa <anilgv@broadcom.com>
Cc: Mike Christie <michaelc@cs.wisc.edu>, Mike Christie <mchristi@redhat.com>, Michael Chan <mchan@broadcom.com>, davem@davemloft.net, netdev@vger.kernel.org, open-iscsi@googlegroups.com, talm@broadcom.com, lusinsky@broadcom.com, uri@broadcom.com, SCSI Mailing List <linux-scsi@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org


Anil Veerabhadrappa wrote:
> It's a chicken & egg issue to put "port mapper" sysfs entry in scsi host
> attributes. Application won't see sysfs unless initiator creates an
> iSCSI session and driver can't create an iSCSI session without a tcp
> port. I was wondering if there is a better way than using IOCTL in this
> situation?

Agree, and IMHO, is why the scsi_host should have been bound to the ISID
or something similar (e.g. the initiator "port" that can have 1 or more
sessions), and the session bound to the scsi_target under the scsi_host.

-- james s
