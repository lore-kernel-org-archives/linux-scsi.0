From: Animesh Singh <animeshs@gmail.com>
Subject: SCSI controller issue.
Date: Wed, 20 Oct 2004 14:04:15 +0530
Sender: linux-poweredge-admin@dell.com
Message-ID: <e8fef13b041020013424f5b018@mail.gmail.com>
References: <e8fef13b041020013136005fe5@mail.gmail.com>
Reply-To: Animesh Singh <animeshs@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-poweredge-admin@dell.com>
In-Reply-To: <e8fef13b041020013136005fe5@mail.gmail.com>
Errors-To: linux-poweredge-admin@dell.com
List-Unsubscribe: <http://lists.us.dell.com/mailman/listinfo/linux-poweredge>,
	<mailto:linux-poweredge-request@dell.com?subject=unsubscribe>
List-Post: <mailto:linux-poweredge@dell.com>
List-Help: <mailto:linux-poweredge-request@dell.com?subject=help>
List-Subscribe: <http://lists.us.dell.com/mailman/listinfo/linux-poweredge>,
	<mailto:linux-poweredge-request@dell.com?subject=subscribe>
List-Archive: <http://lists.us.dell.com/pipermail/linux-poweredge/>
To: linux-poweredge@dell.com
Cc: linux-scsi@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

Afternoon,

I am using PERC 4/D scsi controller card for out Power Vault + RHEL AS
2.1 fro cluster.

1. I got lots of I/O error on filesystem( ext3 ), while using Power
Vault 220s with PERC 3/D scsi controller card.
2. After chaning it to PERC 4/D card am facing following issuse:
    It does not allow me to make more then one LUN on the Power Vault.
    If I have 4 disk in R5 and one HS configured on PV 220s. ( in case
if any disk of R5 fails ) then second node gets different status about
the disk status. i.e on Primary node it shows HS getting in to rebuild
status & over node 2 it gives status of DISK FAIL.)
3. We changed the PERC 3/D to PERC 4/D 'cause of listed reasons:
    It supports 160mpbs, where as PERC 4/D supports 320 mpbs ( which
is the same speed provided by PV Controller.
    SCSI cables from nodes to PV were 10feets long, so we went for
shorter cable.

The issue is that if I take up server live then in case of R5 disk
failure + Primary node failure ( on which service at that time will
run ), then in this case will my secondary node takes up the service
and rebuild the R5 or not?

And the flexbility of having more then one LUN on PERC 3/D is not
support on PERC 4/D SCSI controller card.

Regards,
Animesh.

_______________________________________________
Linux-PowerEdge mailing list
Linux-PowerEdge@dell.com
http://lists.us.dell.com/mailman/listinfo/linux-poweredge
Please read the FAQ at http://lists.us.dell.com/faq
