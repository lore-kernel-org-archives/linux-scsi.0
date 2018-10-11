From: "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: Re: [PATCH 09/16] scsi: Replace spin_is_locked() with lockdep
Date: Wed, 10 Oct 2018 22:37:34 -0400
Message-ID: <yq1ftxd2opd.fsf@oracle.com>
References: <20181003053902.6910-1-ldr709@gmail.com>
        <20181003053902.6910-10-ldr709@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20181003053902.6910-10-ldr709@gmail.com> (Lance Roy's message of
        "Tue, 2 Oct 2018 22:38:55 -0700")
Sender: linux-kernel-owner@vger.kernel.org
To: Lance Roy <ldr709@gmail.com>
Cc: linux-kernel@vger.kernel.org, "Paul E. McKenney" <paulmck@linux.ibm.com>, Karan Tilak Kumar <kartilak@cisco.com>, Sesidhar Baddela <sebaddel@cisco.com>, "James E.J. Bottomley" <jejb@linux.vnet.ibm.com>, "Martin K. Petersen" <martin.petersen@oracle.com>, linux-scsi@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org


Lance,

> lockdep_assert_held() is better suited to checking locking
> requirements, since it won't get confused when someone else holds the
> lock. This is also a step towards possibly removing spin_is_locked().

Applied to 4.20/scsi-queue, thank you!

-- 
Martin K. Petersen	Oracle Linux Engineering
