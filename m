From: "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: Re: [trivial PATCH V2] treewide: Align function definition open/close
	braces
Date: Wed, 21 Mar 2018 18:53:46 -0400
Message-ID: <yq1370trqf9.fsf@oracle.com>
References: <5ccbbf083e26bddfb4ea4f819ed62347ce266f39.1521669820.git.joe@perches.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-audit-bounces@redhat.com>
In-Reply-To: <5ccbbf083e26bddfb4ea4f819ed62347ce266f39.1521669820.git.joe@perches.com>
	(Joe Perches's message of "Wed, 21 Mar 2018 15:09:32 -0700")
List-Unsubscribe: <https://www.redhat.com/mailman/options/linux-audit>,
	<mailto:linux-audit-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/linux-audit>
List-Post: <mailto:linux-audit@redhat.com>
List-Help: <mailto:linux-audit-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/linux-audit>,
	<mailto:linux-audit-request@redhat.com?subject=subscribe>
Sender: linux-audit-bounces@redhat.com
Errors-To: linux-audit-bounces@redhat.com
To: Joe Perches <joe@perches.com>
Cc: linux-wireless@vger.kernel.org, Alexandre Belloni <alexandre.belloni@bootlin.com>, x86@kernel.org, Jeff, Peter Zijlstra <peterz@infradead.org>, Layton <jlayton@kernel.org>, Will Deacon <will.deacon@arm.com>, Timur Tabi <timur@tabi.org>, dri-devel@lists.freedesktop.org, Liam Girdwood <lgirdwood@gmail.com>, "J. Bruce Fields" <bfields@fieldses.org>, Solutions <aacraid@adaptec.com>, "H. Peter Anvin" <hpa@zytor.com>, linux-acpi@vger.kernel.org, linux-kernel@vger.kernel.org, Mauro, linux-rtc@vger.kernel.org, "David (ChunMing) Zhou" <David1.Zhou@amd.com>, "James E.J. Bottomley" <jejb@linux.vnet.ibm.com>, linux-scsi@vger.kernel.org, "Darrick J. Wong" <darrick.wong@oracle.com>, Dept-GELinuxNICDev@cavium.com, Mark Fasheh <mark@fasheh.com>, Sathya Prakash <sathya.prakash@broadcom.com>, amd-gfx@lists.freedesktop.org, David Airlie <airlied@linux.ie>, Andy, Darren Hart <dvhart@inf>
List-Id: linux-scsi@vger.kernel.org


Joe,

> Some functions definitions have either the initial open brace and/or
> the closing brace outside of column 1.
>
> Move those braces to column 1.

drivers/scsi and drivers/message/fusion parts look fine.

Acked-by: Martin K. Petersen <martin.petersen@oracle.com>

-- 
Martin K. Petersen	Oracle Linux Engineering
